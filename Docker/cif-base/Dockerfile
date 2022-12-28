FROM ubuntu:22.04 AS git-repos

ARG DEBIAN_FRONTEND="noninteractive"

# hadolint ignore=DL3009
RUN set -e; set -x \
; apt-get update \
&& apt-get --no-install-recommends install -y \
  ca-certificates \
  git

RUN git clone https://github.com/csirtgadgets/csirtg-indicator-py-v1 /tmp/csirtg-indicator \
&& git clone https://github.com/csirtgadgets/csirtg-smrt-v1 /tmp/csirtg-smrt \
&& git clone https://github.com/csirtgadgets/cifsdk-py-v3 /tmp/cifsdk-py-v3
#&& git clone https://github.com/csirtgadgets/bearded-avenger /tmp/bearded-avenger

################
# hadolint ignore=DL3007
FROM cif-python:latest

ARG DEBIAN_FRONTEND="noninteractive"
ARG VIRTUAL_ENV="/cif_venv"
ARG PATH="$VIRTUAL_ENV/bin:$PATH"

# hadolint ignore=DL3009,DL3013,SC2016
RUN set -e; set -x \
; apt-get update \
&& apt-get --no-install-recommends install -y \
  build-essential \
  git \
  python3-pip \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
&& python3.9 -m venv $VIRTUAL_ENV \
&& python3.9 -m pip install --upgrade --no-cache-dir pip \
&& python3.9 -m pip install --upgrade --no-cache-dir \
  cython \
  pytest \
  setuptools \
  singledispatch \
  wheel

COPY --from=git-repos /tmp/csirtg-indicator /tmp/csirtg-indicator
WORKDIR /tmp/csirtg-indicator
RUN python3.9 -m pip install --no-cache-dir -r requirements.txt \
&& python3.9 -m pip install --no-cache-dir .

COPY --from=git-repos /tmp/csirtg-smrt /tmp/csirtg-smrt
WORKDIR /tmp/csirtg-smrt
RUN python3.9 -m pip install --no-cache-dir -r extras_requirements.txt \
&& python3.9 -m pip install --no-cache-dir .

COPY --from=git-repos /tmp/cifsdk-py-v3 /tmp/cifsdk-py-v3
WORKDIR /tmp/cifsdk-py-v3
RUN python3.9 -m pip install --no-cache-dir -r requirements.txt \
&& python3.9 -m pip install --no-cache-dir .

COPY repos/sesv4_code /tmp/bearded-avenger
WORKDIR /tmp/bearded-avenger
RUN python3.9 -m pip install --no-cache-dir -r dev_requirements.txt \
&& python3.9 setup.py test \
&& python3.9 -m pip install --no-cache-dir .
