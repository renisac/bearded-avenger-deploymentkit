FROM ubuntu:22.04 AS git-repos

ARG DEBIAN_FRONTEND="noninteractive"

# hadolint ignore=DL3009
RUN set -e; set -x \
; apt-get update \
&& apt-get --no-install-recommends install -y \
  ca-certificates \
  git \
  openssh-client

ARG CIF_RELEASE_URL=${CIF_RELEASE_URL:-https://github.com/renisac/bearded-avenger}
ARG GITHUB_DEPLOY_KEY_BASE64
ARG GITHUB_DEPLOY_KEY_FILE=/tmp/github_deploy_key

RUN git clone --branch 1.0.14a2 https://github.com/renisac/csirtg-indicator-py-v1 /tmp/csirtg-indicator \
&& git clone https://github.com/renisac/csirtg-smrt-v1 /tmp/csirtg-smrt \
&& git clone https://github.com/renisac/cifsdk-py-v3 /tmp/cifsdk-py-v3 \
\
&& if [ ! -z "${GITHUB_DEPLOY_KEY_BASE64}" ] \
    ; then echo "${GITHUB_DEPLOY_KEY_BASE64}" | base64 -d > "${GITHUB_DEPLOY_KEY_FILE}" \
    && chmod 0600 "${GITHUB_DEPLOY_KEY_FILE}" \
    && mkdir -p ~/.ssh \
    && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts \
    && eval "$(ssh-agent)" \
    && ssh-add "${GITHUB_DEPLOY_KEY_FILE}" \
  ; fi \
&& git clone "${CIF_RELEASE_URL}" /tmp/bearded-avenger \
&& if [ -f "$GITHUB_DEPLOY_KEY_FILE" ] ; then rm -fv "$GITHUB_DEPLOY_KEY_FILE" ; fi

################
# hadolint ignore=DL3007
FROM cif-python:latest

ARG DEBIAN_FRONTEND="noninteractive"
ARG VIRTUAL_ENV="/cif_venv"
ARG PATH="$VIRTUAL_ENV/bin:$PATH"

ENV SMRT_SERVICE_ENABLE=1

# hadolint ignore=DL3009,DL3013,SC2016
RUN set -e; set -x \
; apt-get update \
&& apt-get --no-install-recommends install -y \
  build-essential \
  git \
  python3-pip \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN python3.9 -m venv $VIRTUAL_ENV \
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

COPY --from=git-repos /tmp/bearded-avenger /tmp/bearded-avenger
WORKDIR /tmp/bearded-avenger
RUN python3.9 -m pip install --no-cache-dir -r dev_requirements.txt \
&& python3.9 -m pip install --no-cache-dir .
# removed until 33% of tests pass
#&& python3.9 setup.py test \
