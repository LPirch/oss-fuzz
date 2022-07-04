FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && apt-get install -y wget
RUN git clone https://github.com/radareorg/radare2 radare2

WORKDIR radare2
COPY *.sh $SRC/


