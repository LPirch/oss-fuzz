FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && \
    apt-get install -y make autoconf

RUN git clone https://github.com/ImageMagick/ImageMagick6.git imagemagick6
WORKDIR imagemagick6
COPY *.sh $SRC/
