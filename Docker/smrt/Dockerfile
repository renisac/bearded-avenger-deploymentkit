#----------------------------------------------------
# hadolint ignore=DL3007
FROM cif-base:latest as builder

#----------------------------------------------------
# s6 builder
#
# install s6 to image
# COPY --from=s6 /tmp/s6-overlay-noarch.tar.xz /tmp/
# COPY --from=s6 /tmp/s6-overlay-x86_64.tar.xz /tmp/
# RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
# && tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
#
# needed on final image to install s6:
# - xz-utils
FROM ubuntu:22.04 as s6

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

# coreutils provides sha256sum
RUN apt-get update \
&& apt-get --no-install-recommends -y install \
  coreutils

ARG S6_VERSION=3.1.0.1

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz.sha256 /tmp/
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz /tmp/
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-x86_64.tar.xz.sha256 /tmp/
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-x86_64.tar.xz /tmp/

RUN \
   sed -i 's/s6-overlay-noarch-.*\.tar\.xz/s6-overlay-noarch\.tar\.xz/g' /tmp/s6-overlay-noarch.tar.xz.sha256 \
&& sed -i 's/s6-overlay-x86_64-.*\.tar\.xz/s6-overlay-x86_64\.tar\.xz/g' /tmp/s6-overlay-x86_64.tar.xz.sha256 \
\
&& sha256sum -c /tmp/s6-overlay-noarch.tar.xz.sha256 \
&& sha256sum -c /tmp/s6-overlay-x86_64.tar.xz.sha256

#----------------------------------------------------
# hadolint ignore=DL3007
FROM cif-python:latest

COPY --from=builder /cif_venv /cif_venv

ARG DEBIAN_FRONTEND="noninteractive"
ARG VIRTUAL_ENV="/cif_venv"
ARG PATH="$VIRTUAL_ENV/bin:$PATH"

# hadolint ignore=DL3009,DL3013,SC2016
RUN set -e; set -x \
; apt-get update \
&& apt-get --no-install-recommends install -y \
  curl \
  xz-utils \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
\
&& adduser \
  --gecos '' \
  --disabled-password \
  cif \
&& chown root:cif /cif_venv \
&& chmod 750 /cif_venv \
&& mkdir /etc/cif \
&& echo "VIRTUAL_ENV=${VIRTUAL_ENV}" > /home/cif/.bash_aliases \
&& echo 'PATH="${VIRTUAL_ENV}/bin:${PATH}"' >> /home/cif/.bash_aliases

COPY --from=builder /tmp/bearded-avenger/rules/default /etc/cif/rules/default
RUN chown root:cif /etc/cif/rules/default/* \
&& chmod 0640 /etc/cif/rules/default/*

COPY --from=s6 /tmp/s6-overlay-noarch.tar.xz /tmp/
COPY --from=s6 /tmp/s6-overlay-x86_64.tar.xz /tmp/
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

COPY ./s6/etc-cont-init.d/ /etc/cont-init.d/
COPY ./s6/etc-s6-overlay-s6-rc.d/ /etc/s6-overlay/s6-rc.d/

RUN chmod 0750 /etc/cont-init.d/*.sh \
&& chown -R root:cif /etc/cont-init.d/ \
\
&& mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d/ \
&& chmod -R 0750 /etc/s6-overlay/s6-rc.d/ \
\
&& touch /etc/s6-overlay/s6-rc.d/user/contents.d/01-csirtg-smrt \
&& chmod 0440 /etc/s6-overlay/s6-rc.d/user/contents.d/* \
\
&& chown -R root:cif /etc/s6-overlay/s6-rc.d/

ENTRYPOINT ["/init"]
