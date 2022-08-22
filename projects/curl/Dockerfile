FROM gcr.io/oss-fuzz-base/base-builder

RUN apt update && apt install -y dh-autoreconf libssl-dev

RUN mkdir -p $SRC/curl
WORKDIR $SRC/curl
COPY *.sh $SRC/
