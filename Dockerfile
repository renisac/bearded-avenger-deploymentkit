FROM ubuntu:18.04

#ENV DEBIAN_FRONTEND noninteractive
#ENV DOCKER_BUILD yes
#ENV CIF_ENABLE_INSTALL 1

ARG DEBIAN_FRONTEND="noninteractive"
ARG DOCKER_BUILD="yes"
ARG CIF_ENABLE_INSTALL=1
ENV LANG C.UTF-8

#ENV CIF_ANSIBLE_ES "${CIF_ANSIBLE_ES}"
#ENV CIF_ANSIBLE_ES_NODES "${CIF_ANSIBLE_ES_NODES}"
#ENV CIF_STORE_ES_UPSERT_MODE "${CIF_STORE_ES_UPSERT_MODE}"
#ENV CIF_ANSIBLE_SDIST "${CIF_ANSIBLE_SDIST}"
#ENV CIF_HUNTER_THREADS "${CIF_HUNTER_THREADS}"
#ENV CIF_HUNTER_ADVANCED "${CIF_HUNTER_ADVANCED}"
#ENV CIF_GATHERER_GEO_FQDN "${CIF_GATHERER_GEO_FQDN}"
#ENV CIF_BOOTSTRAP_TEST "${CIF_BOOTSTRAP_TEST}"
#ENV CIF_ROUTER_TRACE "${CIF_ROUTER_TRACE}"
#ENV CIF_HTTPD_LISTEN "${CIF_HTTPD_LISTEN}"
#ENV CSIRTG_SMRT_GOBACK_DAYS "${CSIRTG_SMRT_GOBACK_DAYS}"

EXPOSE 5000/tcp

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
  curl

RUN python3 -m pip install --upgrade \
  pip \
  setuptools \
  wheel \
&& python3 -m pip install --upgrade \
  cryptography \
&& python3 -m pip install --upgrade \
  'ansible<2.6'

RUN mkdir -p /etc/resolvconf/resolv.conf.d \
&& mkdir /etc/cron.d

COPY ./ /tmp/badk/
WORKDIR /tmp/badk/ubuntu18
RUN ansible-galaxy install elastic.elasticsearch,5.5.1 \
  && ansible-playbook -i "localhost," -c local site.yml -vv
#RUN ansible-playbook -i "localhost," -c local site.yml -vv

RUN apt-get --no-install-recommends install -y vim less tmux htop

WORKDIR /root

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.0/s6-overlay-amd64.tar.gz /tmp/s6-overlay-amd64.tar.gz

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
&& rm -rf /var/lib/apt/lists/* \
&& rm -f /tmp/s6-overlay-amd64.tar.gz \
&& rm -rf /tmp/bearded-avenger \
&& rm -rf /tmp/cifsdk-py-v3 \
&& rm -rf /tmp/csirtg-indicator \
&& rm -rf /tmp/csirtg-smrt \
&& rm -rf /tmp/badk

COPY ./s6/etc-cont-init.d/ /etc/cont-init.d/
COPY ./s6/etc-services.d/ /etc/services.d/

ENTRYPOINT ["/init"]