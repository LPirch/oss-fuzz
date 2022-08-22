FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && apt-get install -y autoconf automake make libtool \
    pkg-config libxml2-dev libghc-zlib-dev libboost-dev

RUN mkdir -p $SRC/torque
WORKDIR $SRC/torque
COPY *.sh $SRC/
