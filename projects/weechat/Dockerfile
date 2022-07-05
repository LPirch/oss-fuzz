FROM gcr.io/oss-fuzz-base/base-builder

RUN apt-get update && apt-get install -y libtool autoconf automake \
                                autopoint pkg-config libgcrypt20-dev \
                                zlib1g-dev libcurl4-openssl-dev gettext \
                                libghc-gnutls-dev libzstd-dev

RUN git clone https://github.com/weechat/weechat.git
WORKDIR weechat

COPY *.sh $SRC/
