FROM ubuntu:16.04

# RUN locale-gen en_US.UTF-8
# ENV LANG en_US.utf8
# ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get install -y \
    autoconf \
    curl \
    gcc \
    g++ \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libevent-dev \
    libssl-dev \
    libtool \
    make \
    pkg-config

RUN apt-get clean

# Build db4.8
WORKDIR /tmp
RUN curl -o db-4.8.30.NC.tar.gz  http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
RUN tar xzf db-4.8.30.NC.tar.gz
WORKDIR /tmp/db-4.8.30.NC/build_unix
RUN ../dist/configure --prefix=/usr --enable-cxx
RUN make -j "$(nproc)"
RUN make install

# Build monacoind
WORKDIR /tmp
RUN curl -o monacoin-0.14.2-x86_64-linux-gnu.tar.gz -L https://github.com/monacoinproject/monacoin/archive/monacoin-0.14.2.tar.gz
RUN tar xzf monacoin-0.14.2-x86_64-linux-gnu.tar.gz
WORKDIR /tmp/monacoin-monacoin-0.14.2
RUN ./autogen.sh
RUN ./configure --disable-tests --disable-bench
RUN make -j "$(nproc)"
RUN make install

VOLUME ["/root/.monacoin"]

# P2P = 9401, RPC = 9402
EXPOSE 9401 9402

CMD ["monacoind"]
