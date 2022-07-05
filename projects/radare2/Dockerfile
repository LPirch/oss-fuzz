FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && apt-get install -y wget pkg-config
RUN git clone https://github.com/radareorg/radare2 radare2

# install capstone5 with position independent code
RUN git clone https://github.com/capstone-engine/capstone.git /opt/capstone
WORKDIR /opt/capstone
RUN git checkout 5.0-rc2
RUN mkdir build && cd build && \
    cmake .. -DVERSION_MAJOR=5 -DVERSION_MINOR=0 -DVERSION_PATCH=0 \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON && \
    make -j$(nproc) install

WORKDIR $SRC/radare2
COPY *.sh $SRC/
