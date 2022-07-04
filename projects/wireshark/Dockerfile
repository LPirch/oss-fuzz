FROM gcr.io/oss-fuzz-base/base-builder

# required packages
RUN apt-get update && apt-get install -y pkg-config libglib2.0-dev \
    qtbase5-dev qttools5-dev libqt5widgets5 qtmultimedia5-dev \
    libpcap-dev python libgcrypt20-dev libc-ares-dev flex gettext

# optinal packages
RUN apt-get install -y libssh-dev systemd python3-maxminddb libghc-gnutls-dev \
    libminizip-dev libkrb5-dev libbrotli-dev liblz4-dev libsnappy-dev \
    libzstd-dev libnghttp2-dev lua5.3 libmnl-dev libsbc-dev \
    libspandsp-dev libopus-dev libxml2-dev asciidoctor doxygen \
    libspeexdsp-dev xsltproc libcap-dev libnl-genl-3-dev \
    libnl-route-3-dev libsystemd-dev libmaxminddb-dev liblua5.3-dev

RUN git clone https://gitlab.com/wireshark/wireshark.git

WORKDIR wireshark

COPY *.sh $SRC/
