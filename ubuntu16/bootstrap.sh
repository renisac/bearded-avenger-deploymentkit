#!/bin/bash

set -e

export CIF_ANSIBLE_ES=$CIF_ANSIBLE_ES
export CIF_ANSIBLE_SDIST=$CIF_ANSIBLE_SDIST
export CIF_HUNTER_THREADS=$CIF_HUNTER_THREADS
export CIF_HUNTER_ADVANCED=$CIF_HUNTER_ADVANCED
export CIF_GATHERER_GEO_FQDN=$CIF_GATHERER_GEO_FQDN
export DEBIAN_FRONTEND=noninteractive

echo 'installing the basics'
#sudo apt-get update && apt-get install -y build-essential python-dev python2.7 python-pip python-dev aptitude \
#    python-pip libffi-dev libssl-dev sqlite3 software-properties-common

apt-get update
apt-get -y dist-upgrade
apt-get install -y build-essential python3-dev python3-minimal python3-pip python3-venv python3-virtualenv python-virtualenv
#apt-get install -y wget unzip openssh-client
apt-get install -y openssh-client

#sudo pip install pip --upgrade
python3 -m pip install --upgrade pip setuptools wheel cryptography
python3 -m pip install --upgrade 'ansible<2.6'
#python3 -m pip install --upgrade 'pytest>=2.8.0,<3.0'

#echo 'checking for python-openssl'
#set +e
#EXISTS=$( dpkg -l | grep python-openssl )
#set -e
#if [[ ! -z ${EXISTS} ]]; then
#	echo "Python-openssl found. Applying workaround"
#	echo "#@link https://github.com/csirtgadgets/bearded-avenger-deploymentkit/issues/15"
#	echo "# sudo apt-get --auto-remove --yes remove python-openssl"
#	echo "# sudo pip install pyOpenSSL"
#	sudo apt-get --auto-remove --yes remove python-openssl && sudo pip install pyOpenSSL
#fi
#
#sudo pip install 'pytest>=2.8.0,<3.0'
#
bash ../ansible.sh

if [[ "$CIF_BOOTSTRAP_TEST" -eq '1' ]]; then
    bash ../test.sh
fi
