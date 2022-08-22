FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && apt-get install -y autoconf automake make

RUN mkdir -p $SRC/tnef
WORKDIR $SRC/tnef
COPY *.sh $SRC/
