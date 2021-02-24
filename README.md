# Getting Started

* this deployment runs on Ubuntu 18.04
* cif and the dependencies run in a python 3.6 venv
  * python 3.6 is the version shipped with Ubuntu 18.04
* this sets up the latest versions of cifv3 and dependencies

## Working

* Ubuntu 18.04
  * sqlite3 or ES backend
  * pytests and bootstrap tests

## Todo

* fix sdist.yml (cif-ansible-role repo)
* Docker support

## Wontfix

* CentOS/RHEL support

## Installation

* do all of this as root

* clone this repo

      git clone --branch 1804 https://github.com/chodonne/bearded-avenger-deploymentkit

* clone the cif-ansible-role into proper location

      git clone --branch 1804 https://github.com/chodonne/cif-ansible-role bearded-avenger-deploymentkit/roles/csirtgadgets.cif

* install options

  * install with sqlite backend (default)

        cd bearded-avenger-deploymentkit
        /bin/bash easybutton.sh

  * install with Elastic backend and do bootstrap tests (this just adds all 3 env vars listed below before running easybutton.sh)

        cd bearded-avenger-deploymentkit
        /bin/bash easybutton_with_es_and_bootstrap_tests.sh

  * misc env vars

    * install with Elastic backend

          CIF_ANSIBLE_ES='localhost:9200'

    * ES upsert mode (use only with ES backend)

          CIF_STORE_ES_UPSERT_MODE=1

    * run bootstrap tests

          CIF_BOOTSTRAP_TEST=1


---

[See the Wiki...](https://github.com/csirtgadgets/bearded-avenger-deploymentkit/wiki)
