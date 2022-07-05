FROM gcr.io/oss-fuzz-base/base-builder

RUN apt update && apt install -y dh-autoreconf libssl-dev
RUN git clone https://github.com/curl/curl.git $SRC/curl

WORKDIR $SRC/curl
COPY *.sh $SRC/
