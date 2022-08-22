# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && \
    apt-get install -y make libtool automake autoconf pkg-config \
        libsystemd-dev docbook-to-man libcap-dev libseccomp-dev \
        libselinux1-dev libapparmor-dev libssl-dev ninja-build
RUN pip3 install --user --upgrade meson cmake
ENV PATH="/root/.local/bin:${PATH}"

RUN mkdir -p $SRC/lxc
WORKDIR $SRC/lxc
COPY *.sh $SRC/
