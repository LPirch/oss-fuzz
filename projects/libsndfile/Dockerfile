FROM gcr.io/oss-fuzz-base/base-builder
RUN apt update && apt install -y autoconf autogen automake libtool pkg-config python \
                                 libasound2-dev libflac-dev libogg-dev libopus-dev libvorbis-dev

RUN mkdir -p $SRC/libsndfile
WORKDIR $SRC/libsndfile
COPY *.sh $SRC/
