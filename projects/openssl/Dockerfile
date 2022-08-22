# Copyright 2016 Google Inc.
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
RUN apt-get update && apt-get install -y make perlbrew libssl-dev

# patch perl to an old version because older opsenssl versions rely on deprecated perl features
RUN perlbrew init && echo "source ~/perl5/perlbrew/etc/bashrc" >> ~/.profile
RUN perlbrew install -n -j8 5.20.3

RUN mkdir -p $SRC/openssl
WORKDIR $SRC/openssl
COPY *.sh $SRC/
