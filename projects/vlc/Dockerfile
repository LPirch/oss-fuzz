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
RUN apt-get update && apt-get install -y gettext flex \
    bison libtool libasound2-dev lua5.3 \
    liblua5.2-dev libavutil-dev libavcodec-dev libgstreamer1.0-dev \
    libavformat-dev libswscale-dev libpostproc-dev liba52-dev \
    librust-dbus-dev libmpeg2-4-dev libfaad-dev vlc-plugin-skins2 \
    libfribidi-dev mkvtoolnix xcb libalsaplayer-dev libxcb1-dev \
    libxcb-composite0-dev libxcb-randr0-dev libxcb-render0-dev \
    libxcb-shape0-dev libxcb-xkb-dev libxcb-shm0-dev libqt5core5a \
    qtbase5-dev libqt5opengl5-dev qtdeclarative5-dev libqt5svg5-dev \
    liba52-0.7.4-dev libgcrypt20-dev libxcb-xv0-dev libdvbpsi-dev \
    libgme-dev libsidplay2-dev libogg-dev libshout3-dev libmatroska-dev \
    libmikmod-dev gmpc-dev libmodplug-dev

RUN mkdir -p $SRC/vlc
WORKDIR $SRC/vlc
COPY *.sh $SRC/

