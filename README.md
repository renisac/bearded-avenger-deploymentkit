# Getting Started

* this deployment runs on Ubuntu 18.04
* cif and the dependencies run in a python 3.6 venv
  * python 3.6 is the version shipped with Ubuntu 18.04
* this sets up the latest versions of cifv3 and dependencies

## Working

* Ubuntu 18.04
  * sqlite3 or ES backend
  * pytests and bootstrap tests
  * Docker support

## Todo

* fix sdist.yml (cif-ansible-role repo)

## Wontfix

* CentOS/RHEL support

## Setup

* clone this repo

      git clone --branch 1804 https://github.com/chodonne/bearded-avenger-deploymentkit

* clone the cif-ansible-role into proper location

      git clone --branch 1804 https://github.com/chodonne/cif-ansible-role bearded-avenger-deploymentkit/roles/csirtgadgets.cif

## Installation (VM or bare metal)

* do all of this as root

* choose a backend for the installation

  * install with sqlite backend (default)

        cd bearded-avenger-deploymentkit
        /bin/bash easybutton.sh

  * install with Elastic backend

        cd bearded-avenger-deploymentkit
        CIF_ANSIBLE_ES='localhost:9200'; /bin/bash easybutton.sh

  * install with Elastic backend and do bootstrap tests (this just adds all 3 env vars listed below before running easybutton.sh)

        cd bearded-avenger-deploymentkit
        /bin/bash easybutton_with_es_and_bootstrap_tests.sh

* other useful env vars

  * run bootstrap tests

        CIF_BOOTSTRAP_TEST=1

  * ES upsert mode (use only with ES backend)

        CIF_STORE_ES_UPSERT_MODE=1

  * install with Elastic backend

        CIF_ANSIBLE_ES='localhost:9200'

  * change smrt.db directory

        CIF_ANSIBLE_SMRT_DB_PATH='/new/path'

## Docker

* Requirements: have docker and docker-compose installed

* build image (same for sqlite3 or ES backends)

      cd bearded-avenger-deploymentkit
      docker-compose build

* To use the sqlite backend:

      docker-compose up -d

* to use the Elastic backend:

      cp docker-compose.elasticsearch.yml docker-compose.override.yml
      docker-compose up -d

* get a shell on running container, switch to cif user, and test connectivity

      docker-compose exec cifv3 /bin/bash
      sudo -u cif -i
      cif -p

* useful env vars

  * set API keys for admin, hunter, and smrt at container runtime.
    API keys are 80 character hexidecimal strings.

        CIF_TOKEN
        CIF_HUNTER_TOKEN
        CIF_HTTPD_TOKEN
        CSIRTG_SMRT_TOKEN

  * set cif-httpd to listen externally (defaults to 127.0.0.1:5000)

        CIF_HTTPD_LISTEN="0.0.0.0"

  * prevent smrt service from running

        SERVICE_STOP_SMRT=1

  * enable https

        DOCKER_HTTPS=1


    * If using the docker-compose.yml file, be sure to expose the https port
    * to override the self signed certificates, bind mount the correct certs
      at the following paths:

          ssl_certificate /etc/nginx/ssl/nginx.crt;
          ssl_certificate_key /etc/nginx/ssl/nginx.key;

---

[Original Wiki](https://github.com/csirtgadgets/bearded-avenger-deploymentkit/wiki)
