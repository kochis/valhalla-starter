# Dockerfile to build Valhalla
ARG VALHALLA_VERSION=3.1.0
ARG VALHALLA_REPO=https://github.com/valhalla/valhalla.git
ARG PRIME_SERVER_TAG=0.7.0
FROM ubuntu:18.04
ARG VALHALLA_VERSION
ARG VALHALLA_REPO
ARG PRIME_SERVER_TAG

# Install base packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    curl \
    g++ \
    gcc \
    git \
    jq \
    lcov \
    libboost-all-dev \
    libboost-python-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libczmq-dev \
    libexpat1-dev \
    libgeos++-dev \
    libgeos-dev \
    libluajit-5.1-dev \
    liblz4-dev \
    libspatialite-dev \
    libsqlite3-dev \
    libsqlite3-mod-spatialite \
    libprotobuf-dev \
    libprotobuf-lite10 \
    libtool \
    libzmq3-dev \
    make \
    osmctools \
    osmosis \
    parallel \
    pkg-config \
    protobuf-compiler \
    python-all-dev \
    python-pip \
    python-virtualenv \
    software-properties-common \
    spatialite-bin \
    vim-common \
    wget \
    zlib1g-dev

RUN mkdir -p /src && cd /src

# prime_server
RUN git clone -v --branch ${PRIME_SERVER_TAG} https://github.com/kevinkreiser/prime_server.git && (cd prime_server && git submodule update --init --recursive && ./autogen.sh && ./configure --prefix=/usr LIBS="-lpthread" && make all -j$(nproc) && make -j$(nproc) -k test && make install && cd ..)

# valhalla
RUN git clone https://github.com/valhalla/valhalla.git && (cd valhalla && git checkout tags/${VALHALLA_VERSION} -b build && git submodule update --init --recursive && mkdir -p build && cd build && cmake .. -DPKG_CONFIG_PATH=/usr/local/lib/pkgconfig -DCMAKE_BUILD_TYPE=Release -DENABLE_NODE_BINDINGS=OFF && make -j2 install) && rm -rf /src
