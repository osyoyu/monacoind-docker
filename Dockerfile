FROM alpine:3.7

RUN apk update
RUN apk add \
  autoconf \
  automake \
  boost-dev \
  coreutils \
  curl \
  file \
  gcc \
  g++ \
  libevent-dev \
  libtool \
  make \
  openssl-dev

# Build db4.8
WORKDIR /tmp
RUN curl -o db-4.8.30.NC.tar.gz  http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
RUN tar xzvf db-4.8.30.NC.tar.gz
WORKDIR /tmp/db-4.8.30.NC/build_unix
RUN ../dist/configure --prefix=/usr --enable-cxx
RUN make -j "$(nproc)"
RUN make install

# Build monacoind
WORKDIR /tmp
RUN curl -o monacoin-0.14.2-x86_64-linux-gnu.tar.gz -L https://github.com/monacoinproject/monacoin/archive/monacoin-0.14.2.tar.gz
RUN tar xzvf monacoin-0.14.2-x86_64-linux-gnu.tar.gz
WORKDIR /tmp/monacoin-monacoin-0.14.2
RUN ./autogen.sh
RUN ./configure
RUN make -j "$(nproc)"
RUN make install

CMD ["monacoind"]
