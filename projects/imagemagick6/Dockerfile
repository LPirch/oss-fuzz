FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && \
    apt-get install -y make autoconf

RUN mkdir -p $SRC/ImageMagick6
WORKDIR $SRC/ImageMagick6
COPY *.sh $SRC/
