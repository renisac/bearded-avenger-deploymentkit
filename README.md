# Getting Started

* this sets up the latest versions of cifv3 and dependencies
* cif and the dependencies run in a python 3.5 venv

## Working

* Ubuntu 16.04
  * sqlite3 or ES backend
  * pytests and bootstrap tests

## Todo

* fix sdist.yml (cif-ansible-role repo)
* Docker support
* investigate newer OS
* investigate newer python version

## Wontfix

* CentOS/RHEL support

## Installation

* do all of this as root

* clone this repo

      git clone https://github.com/chodonne/bearded-avenger-deploymentkit

* clone the cif-ansible-role into proper location

      git clone https://github.com/chodonne/cif-ansible-role bearded-avenger-deploymentkit/roles/csirtgadgets.cif

* choose a backend for the installation

  * install with sqlite backend (default)

        cd bearded-avenger-deploymentkit
        /bin/bash easybutton.sh

  * install with Elastic backend

        cd bearded-avenger-deploymentkit
        CIF_ANSIBLE_ES='localhost:9200'; /bin/bash easybutton.sh

* other useful env vars

  * run bootstrap tests

        CIF_BOOTSTRAP_TEST=1

  * ES upsert mode (use only with ES backend)

        CIF_STORE_ES_UPSERT_MODE=1

---

[See the Wiki...](https://github.com/csirtgadgets/bearded-avenger-deploymentkit/wiki)
