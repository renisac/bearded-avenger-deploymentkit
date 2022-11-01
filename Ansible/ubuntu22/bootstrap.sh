#!/bin/bash

set -e

export CIF_ANSIBLE_ES=$CIF_ANSIBLE_ES
export CIF_ANSIBLE_SDIST=$CIF_ANSIBLE_SDIST
export CIF_ANSIBLE_SMRT_DB_PATH=$CIF_ANSIBLE_SMRT_DB_PATH
export CIF_HUNTER_THREADS=$CIF_HUNTER_THREADS
export CIF_HUNTER_ADVANCED=$CIF_HUNTER_ADVANCED
export CIF_GATHERER_GEO_FQDN=$CIF_GATHERER_GEO_FQDN
export DEBIAN_FRONTEND=noninteractive

echo 'installing the basics'

apt-get update
apt-get -y dist-upgrade
apt-get install -y build-essential python3-dev python3-minimal python3-pip python3-venv python3-virtualenv
apt-get install -y openssh-client software-properties-common

python3 -m pip install --upgrade pip
python3 -m pip install --upgrade setuptools
python3 -m pip install --upgrade wheel
python3 -m pip install --upgrade cryptography
python3 -m pip install --upgrade 'ansible<2.6'
#python3 -m pip install --upgrade 'pytest>=2.8.0,<3.0'

bash ../ansible.sh

if [[ "$CIF_BOOTSTRAP_TEST" -eq '1' ]]; then
    bash ../test.sh
fi
