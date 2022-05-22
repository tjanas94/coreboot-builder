FROM debian:11-slim

RUN apt update \
    && apt install -y \
    automake \
    autopoint \
    bison \
    build-essential \
    curl \
    flex \
    gettext \
    git \
    gnat \
    libfreetype6-dev \
    libncurses5-dev \
    m4 \
    mdm \
    nasm \
    pkg-config \
    python \
    unifont \
    uuid-dev \
    zlib1g-dev \
    && apt -qy clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
    && mkdir -p /workspace \
    && useradd -md /home/builder -s /bin/bash builder \
    && chown builder:builder /workspace

USER builder
WORKDIR /workspace
