#!/usr/bin/env python
"""Extract ASTs from oss-fuzz projects."""

import argparse
import logging
import os
import pipes
import re
import subprocess
import sys
from tempfile import TemporaryDirectory
import time
import gzip
from shutil import rmtree, move
from zipfile import ZipFile, ZIP_STORED

from joblib import delayed, Parallel, parallel_backend

DOCKER_TIMEOUT = 4          # Timeout value
DOCKER_MEMLIMIT = "15g"     # Memory limit for each docker container
DOCKER_TIMEOUT_UNIT = "h"   # Timeout unit
OSS_FUZZ_DIR = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
BUILD_DIR = os.path.join(OSS_FUZZ_DIR, 'build')

PROJECT_LANGUAGE_REGEX = re.compile(r'\s*language\s*:\s*([^\s]+)')
WORKDIR_REGEX = re.compile(r'\s*WORKDIR\s*([^\s]+)')

if sys.version_info[0] >= 3:
  raw_input = input  # pylint: disable=invalid-name

# pylint: disable=too-many-lines


class Project:
  """Class representing a project that is in OSS-Fuzz or an external project
  (ClusterFuzzLite user)."""

  def __init__(self, project_name_or_path, build_dir, commit=None):
    self.commit = commit
    self.name = project_name_or_path
    self.build_dir = build_dir
    self.path = os.path.join(OSS_FUZZ_DIR, 'projects', self.name)
    self.build_integration_path = self.path

  @property
  def dockerfile_path(self):
    """Returns path to the project Dockerfile."""
    return os.path.join(self.build_integration_path, 'Dockerfile')

  @property
  def language(self):
    """Returns project language."""
    project_yaml_path = os.path.join(self.path, 'project.yaml')
    with open(project_yaml_path) as file_handle:
      content = file_handle.read()
      for line in content.splitlines():
        match = PROJECT_LANGUAGE_REGEX.match(line)
        if match:
          return match.group(1)

    logging.warning('Language not specified in project.yaml.')
    return None

  @property
  def out(self):
    """Returns the out dir for the project. Creates it if needed."""
    return self._get_project_build_subdir('out')

  @property
  def work(self):
    """Returns the out dir for the project. Creates it if needed."""
    return self._get_project_build_subdir('work')

  @property
  def corpus(self):
    """Returns the out dir for the project. Creates it if needed."""
    return self._get_project_build_subdir('corpus')

  def _get_project_build_subdir(self, subdir_name):
    """Creates the |subdir_name| subdirectory of the |project| subdirectory in
    |BUILD_DIR|, creates it if not existent and returns its path."""
    directory = os.path.join(self.build_dir, subdir_name, self.name, self.commit).rstrip('/')
    if not os.path.exists(directory):
      os.makedirs(directory, exist_ok=True)
    return directory


def main():  # pylint: disable=too-many-branches,too-many-return-statements
  """Gets subcommand from program arguments and does it. Returns 0 on success 1
  on error."""

  logging.basicConfig(level=logging.INFO)

  parser = get_parser()
  args = parse_args(parser)
  if not os.path.exists(args.build_dir):
    os.mkdir(args.build_dir)
  targets = [] if args.targets is None else [t for t_list in args.targets for t in t_list]
  extra_targets = [] if args.extra_targets is None else [t for t_list in args.extra_targets for t in t_list]
  result = extract_asts(args.project, targets, extra_targets, args.clean, args.rollback, args.source_path, args.commit, args.cpus,
                        mount_path=args.mount_path, zip_results=args.zip_results, passuser=args.passuser)
  return bool_to_retcode(result)


def bool_to_retcode(boolean):
  """Returns 0 if |boolean| is Truthy, 0 is the standard return code for a
  successful process execution. Returns 1 otherwise, indicating the process
  failed."""
  return 0 if boolean else 1


def parse_args(parser, args=None):
  """Parses |args| using |parser| and returns parsed args. Also changes
  |args.build_integration_path| to have correct default behavior."""
  # Use default argument None for args so that in production, argparse does its
  # normal behavior, but unittesting is easier.
  parsed_args = parser.parse_args(args)
  project = getattr(parsed_args, 'project', None)
  if not project:
    return parsed_args

  # Use hacky method for extracting attributes so that ShellTest works.
  parsed_args.project = Project(parsed_args.project, parsed_args.build_dir, parsed_args.commit)

  if parsed_args.build_dir is not None:
    global BUILD_DIR
    BUILD_DIR = os.path.join(OSS_FUZZ_DIR, parsed_args.build_dir)
  return parsed_args


def get_parser():  # pylint: disable=too-many-statements
  """Returns an argparse parser."""
  parser = argparse.ArgumentParser('ast_extraction.py', description='AST extraction (based on helper.py build_fuzzers)')
  parser.add_argument('project')
  parser.add_argument('-t','--target', action='append', nargs=1, dest='targets', help='main make target')
  parser.add_argument('-e','--extra', action='append', nargs=1, dest='extra_targets', help='optional make target')
  parser.add_argument('--source-path', dest='source_path', default=None, help='path of local source')
  parser.add_argument('--commit', help='project commit to rollback to', default="")
  parser.add_argument('--cpus', dest='cpus', type=float, default=8.0, help='number of CPUs to use (may be float)')
  parser.add_argument('--zip', dest='zip_results', action='store_true', default=False, help='zip the results in project.out to save space')
  parser.add_argument('--mount_path', dest='mount_path', help='path to mount local source in (defaults to WORKDIR)')
  parser.add_argument('--clean', dest='clean', action='store_true', default=False, help='clean existing artifacts.')
  parser.add_argument('--no-clean', dest='clean', action='store_false', help='do not clean existing artifacts (default).')
  parser.add_argument('--no-rollback', dest='rollback', action='store_false', help='do not perform a rollback.')
  parser.add_argument('--passuser',  dest='passuser', action='store_true', default=False, help='whether to pass the current UID:GID to the docker container')
  parser.add_argument('--build-dir', type=str, default=BUILD_DIR, dest='build_dir', help='change the default output dir root')
  parser.set_defaults(clean=False, rollback=True)
  return parser


def is_base_image(image_name):
  """Checks if the image name is a base image."""
  return os.path.exists(os.path.join('infra', 'base-images', image_name))


def check_project_exists(project):
  """Checks if a project exists."""
  if not os.path.exists(project.path):
    logging.error('%s does not exist.', project.name)
    return False
  return True


def _get_absolute_path(path):
  """Returns absolute path with user expansion."""
  return os.path.abspath(os.path.expanduser(path))


def _get_command_string(command):
  """Returns a shell escaped command string."""
  return ' '.join(pipes.quote(part) for part in command)


def build_image_impl(project, cache=True):
  """Builds image."""
  image_name = project.name

  if is_base_image(image_name):
    image_project = 'oss-fuzz-base'
    docker_build_dir = os.path.join(OSS_FUZZ_DIR, 'infra', 'base-images',
                                    image_name)
    dockerfile_path = os.path.join(docker_build_dir, 'Dockerfile')
  else:
    if not check_project_exists(project):
      return False
    dockerfile_path = project.dockerfile_path
    docker_build_dir = project.path
    image_project = 'oss-fuzz'

  build_args = []
  if not cache:
    build_args.append('--no-cache')

  build_args += [
      '-t',
      f'gcr.io/{image_project}/{image_name.lower()}',
      '--file', dockerfile_path
  ]
  build_args.append(docker_build_dir)
  return docker_build(build_args)


def _env_to_docker_args(env_list):
  """Turns envirnoment variable list into docker arguments."""
  return sum([['-e', v] for v in env_list], [])


def workdir_from_lines(lines, default='/src'):
  """Gets the WORKDIR from the given lines."""
  for line in reversed(lines):  # reversed to get last WORKDIR.
    match = re.match(WORKDIR_REGEX, line)
    if match:
      workdir = match.group(1)
      workdir = workdir.replace('$SRC', '/src')

      if not os.path.isabs(workdir):
        workdir = os.path.join('/src', workdir)

      return os.path.normpath(workdir)

  return default


def _workdir_from_dockerfile(project):
  """Parses WORKDIR from the Dockerfile for the given project."""
  with open(project.dockerfile_path) as file_handle:
    lines = file_handle.readlines()

  return workdir_from_lines(lines, default=os.path.join('/src', project.name))


def docker_run(run_args, print_output=True):
  """Calls `docker run`."""
  command = ['docker', 'run', '--rm', '--privileged']

  # Support environments with a TTY.
  if sys.stdin.isatty():
    command.append('-i')

  command.extend(run_args)

  logging.info('Running: %s.', _get_command_string(command))
  stdout = None
  if not print_output:
    stdout = open(os.devnull, 'w')

  try:
    subprocess.check_call(command, stdout=stdout, stderr=subprocess.STDOUT)
  except subprocess.CalledProcessError:
    return False

  return True


def docker_build(build_args):
  """Calls `docker build`."""
  command = ['docker', 'build']
  command.extend(build_args)
  logging.info('Running: %s.', _get_command_string(command))

  try:
    subprocess.check_call(command)
  except subprocess.CalledProcessError:
    logging.error('Docker build failed.')
    return False

  return True


def docker_pull(image):
  """Call `docker pull`."""
  command = ['docker', 'pull', image]
  logging.info('Running: %s', _get_command_string(command))

  try:
    subprocess.check_call(command)
  except subprocess.CalledProcessError:
    logging.error('Docker pull failed.')
    return False

  return True


def extract_asts(project, targets, extra_targets, clean, rollback, source_path, commit, cpus, mount_path, zip_results, passuser):
  """ Extract ASTs. """
  if targets is None:
    targets = []
  if extra_targets is None:
    extra_targets = []

  # build image if necessary
  if not build_image_impl(project):
    return False

  if clean:
    logging.info('Cleaning existing build artifacts.')

    # Clean old and possibly conflicting artifacts in project's out directory.
    docker_run([
        '-m', DOCKER_MEMLIMIT,
        f'--cpus={cpus}',
        '-v',
        '%s:/out' % _get_absolute_path(project.out), '-t',
        f'gcr.io/oss-fuzz/{project.name.lower()}',
        'timeout', '-k', '120', f'{DOCKER_TIMEOUT}{DOCKER_TIMEOUT_UNIT}', '/bin/bash', '-c', 'rm -rf /out/*'
    ])

    docker_run([
        '-m', DOCKER_MEMLIMIT,
        f'--cpus={cpus}',
        '-v',
        '%s:/work' % _get_absolute_path(project.work), '-t',
        f'gcr.io/oss-fuzz/{project.name.lower()}',
        'timeout', '-k', '120', f'{DOCKER_TIMEOUT}{DOCKER_TIMEOUT_UNIT}', '/bin/bash', '-c', 'rm -rf /work/*'
    ])

  else:
    logging.info('Keeping existing build artifacts as-is (if any).')

  env = [
      'PROJECT=' + project.name,
      'COMMIT=' + commit,
      f'ROLLBACK={"1" if rollback else "0"}'
  ]

  command = ['--cap-add', 'SYS_PTRACE'] + _env_to_docker_args(env)
  if not source_path:
    raise RuntimeError("source_path must be set!")
  workdir = _workdir_from_dockerfile(project)

  target_opts = []
  for t in targets:
    target_opts.extend(['-t', t])
  extra_target_opts = []
  for t in extra_targets:
    extra_target_opts.extend(['-e', t])

  command += [
      '-m', DOCKER_MEMLIMIT,
      f'--cpus={cpus}', '-t',
      '-v', f'{_get_absolute_path(project.out)}:/out', 
      '-v', f'{_get_absolute_path(project.work)}:/work',
      '-v', f'{_get_absolute_path(source_path)}:{workdir}',
      f'gcr.io/oss-fuzz/{project.name.lower()}',
      'timeout', '-k', '120', '-s', 'KILL', f'{DOCKER_TIMEOUT}{DOCKER_TIMEOUT_UNIT}',
      # '/bin/bash']
      'extract_ast'
  ] + target_opts + extra_target_opts

  print("compile", time.time())
  result = docker_run(command)
  print("compile", time.time())
  if not result:
    logging.error('Building fuzzers failed.')
    return False

  if passuser:
      # chown results
      docker_run([
          '-t',
          '-v', f'{_get_absolute_path(project.out)}:/out',
          '-v', f'{_get_absolute_path(project.work)}:/work',
          '-v', f'{_get_absolute_path(source_path)}:{workdir}',
          f'gcr.io/oss-fuzz/{project.name.lower()}',
          'timeout', '-k', '120', f'{DOCKER_TIMEOUT}{DOCKER_TIMEOUT_UNIT}', 
          '/bin/bash', '-c', f'chown -R {os.getuid()}:{os.getgid()} /out /work {workdir}'
      ])

  if zip_results:
    fast_zipping(project)
  return True


def dump_build_stats(targets, extra_targets, out_dir, file_name='build_stats.csv'):
  out_path = os.path.join(out_dir, file_name)
  header = 'target,type,success'
  with open(out_path, 'w') as csv:
    csv.write(f"{header}\n")
    for target in targets:
      success = 1 if os.path.exists(os.path.join(out_dir, target)) else 0
      csv.write(f"{target},main,{success}\n")
    for extra in extra_targets:
      success = 1 if os.path.exists(os.path.join(out_dir, extra)) else 0
      csv.write(f"{extra},extra,{success}\n")
  return out_path


def fast_zipping(project, jobs=-1):
  n_jobs = jobs
  if n_jobs <= 0:
    n_jobs = os.cpu_count()

  build_stats = os.path.join(project.out, 'build_stats.csv')
  if os.path.exists(build_stats):
    move(build_stats, os.path.dirname(project.out))
  target_zip = f"{project.out}.zip"
  if os.path.exists(target_zip):
    os.remove(target_zip)
  
  # gzip all JSON ASTs
  json_filter = lambda root, f: root.startswith(f'{project.out}/{project.name}') and f.startswith('AST_') and f.endswith('.json')
  json_files = [os.path.join(root, f) for root, _, files in os.walk(project.out) for f in files if json_filter(root, f)]
  n_jobs = min(n_jobs, len(json_files))
  print(f"Fast zipping results in {project.out} using {n_jobs} job{'s' if n_jobs > 1 else ''}")
  with parallel_backend('loky'):
    Parallel(n_jobs=n_jobs)(delayed(
      _gzip_single)(f,) for f in json_files)
  # make_archive(project.out, 'zip', project.out)
  with ZipFile(target_zip, mode='w', compression=ZIP_STORED) as z:
    for json_file in json_files:
      gz_file = f'{json_file}.gz'
      arcname = gz_file
      if arcname.startswith(project.out):
        arcname = arcname[len(project.out):].lstrip('/')
      z.write(gz_file, arcname=arcname)
  rmtree(project.out)
  os.makedirs(project.out, exist_ok=True)
  move(target_zip, os.path.join(project.out, f"{project.name}.zip"))


def _gzip_single(in_file, suffix='.gz'):
  out_file = f'{in_file}{suffix}'
  with open(in_file, 'rb') as f:
    content = f.read()
  with gzip.open(out_file, 'wb') as f:
    f.write(content)
  os.remove(in_file)


if __name__ == '__main__':
  sys.exit(main())
