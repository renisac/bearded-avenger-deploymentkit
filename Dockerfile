FROM ubuntu:18.04

ARG DEBIAN_FRONTEND="noninteractive"
ARG DOCKER_BUILD="yes"
ARG CIF_ENABLE_INSTALL=1

ARG CIF_ANSIBLE_ES
ARG CIF_RELEASE_URL
ARG GITHUB_DEPLOY_KEY_BASE64
ARG GITHUB_DEPLOY_KEY_FILE

ARG S6_VERSION=2.2.0.3

ENV LANG C.UTF-8

#ENV CIF_ANSIBLE_ES_NODES "${CIF_ANSIBLE_ES_NODES}"
#ENV CIF_STORE_ES_UPSERT_MODE "${CIF_STORE_ES_UPSERT_MODE}"
#ENV CIF_ANSIBLE_SDIST "${CIF_ANSIBLE_SDIST}"
#ENV CIF_HUNTER_THREADS "${CIF_HUNTER_THREADS}"
#ENV CIF_HUNTER_ADVANCED "${CIF_HUNTER_ADVANCED}"
#ENV CIF_GATHERER_GEO_FQDN "${CIF_GATHERER_GEO_FQDN}"
#ENV CIF_ROUTER_TRACE "${CIF_ROUTER_TRACE}"
#ENV CIF_HTTPD_LISTEN "${CIF_HTTPD_LISTEN}"
#ENV CSIRTG_SMRT_GOBACK_DAYS "${CSIRTG_SMRT_GOBACK_DAYS}"

RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections \
&& apt-get update \
&& apt-get --no-install-recommends install -y \
  build-essential \
  sudo \
  git \
  resolvconf \
  python3-dev \
  python3-minimal \
  python3-pip \
  python3-venv \
  python3-virtualenv \
  libmagic1 \
  curl \
  gnupg \
  ssh \
&& python3 -m pip install --upgrade \
  pip \
  setuptools \
  wheel \
&& python3 -m pip install --upgrade \
  cryptography \
&& python3 -m pip install --upgrade \
  'ansible<2.6' \
&& mkdir -p /etc/resolvconf/resolv.conf.d \
&& mkdir /etc/cron.d

COPY ./Ansible/ /tmp/badk/
WORKDIR /tmp/badk/ubuntu18
RUN ansible-galaxy install elastic.elasticsearch,5.5.1

# Single step so that deploy key is not committed to image
RUN if [ ! -z "$GITHUB_DEPLOY_KEY_BASE64" ] \
    ; then echo "$GITHUB_DEPLOY_KEY_BASE64" | base64 -d > "$GITHUB_DEPLOY_KEY_FILE" \
  ; fi \
  && if [ -f "$GITHUB_DEPLOY_KEY_FILE" ] ; then chmod 0600 "$GITHUB_DEPLOY_KEY_FILE" ; fi \
  && ansible-playbook -i "localhost," -c local site.yml -vv \
  && if [ -f "$GITHUB_DEPLOY_KEY_FILE" ] ; then rm -fv "$GITHUB_DEPLOY_KEY_FILE" ; fi

WORKDIR /root

ADD https://keybase.io/justcontainers/key.asc /tmp/justcontainers.asc
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64-installer.sig /tmp/
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64-installer /tmp/

RUN gpg --import /tmp/justcontainers.asc \
&& gpg --verify /tmp/s6-overlay-amd64-installer.sig /tmp/s6-overlay-amd64-installer \
&& chmod +x /tmp/s6-overlay-amd64-installer \
&& /tmp/s6-overlay-amd64-installer / \
&& rm -f /tmp/s6-overlay-amd64-installer \
  /tmp/s6-overlay-amd64-installer.sig \
  /tmp/justcontainers.asc \
&& rm -rf /var/lib/apt/lists/* \
  /tmp/bearded-avenger \
  /tmp/cifsdk-py-v3 \
  /tmp/csirtg-indicator \
  /tmp/csirtg-smrt \
  /tmp/badk

COPY ./s6/etc-cont-init.d/ /etc/cont-init.d/
COPY ./s6/etc-services.d/ /etc/services.d/

ENTRYPOINT ["/init"]