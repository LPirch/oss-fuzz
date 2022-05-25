FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && apt-get install -y autoconf automake make
RUN git clone https://github.com/verdammelt/tnef.git
WORKDIR $SRC/tnef
COPY *.sh $SRC/
