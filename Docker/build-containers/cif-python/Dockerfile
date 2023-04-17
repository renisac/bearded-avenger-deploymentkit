FROM ubuntu:22.04

ARG DEBIAN_FRONTEND="noninteractive"

RUN set -e; set -x \
; apt-get update \
&& apt-get --no-install-recommends install -y \
  apt-transport-https \
  ca-certificates \
  gnupg \
  libmagic1 \
  software-properties-common \
&& add-apt-repository ppa:deadsnakes/ppa \
&& apt-get update \
&& apt-get --no-install-recommends install -y \
  python3.9-dev \
  python3.9-minimal \
  python3.9-venv \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
