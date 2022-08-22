FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && apt-get install -y libpcre3 libpcre3-dev \
                                        libexpat1 libexpat1-dev libxml2 \
                                        libxml2-dev subversion libtool \
                                        libtool-bin autoconf automake \
                                        flex bison pkg-config


RUN mkdir -p $SRC/httpd
WORKDIR $SRC/httpd
COPY *.sh $SRC/
