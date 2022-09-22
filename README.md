# Notice

This is a temporary fork of the [CSIRT Gadgets bearded-avenger-deploymentkit repository](https://github.com/csirtgadgets/bearded-avenger-deploymentkit).

The plan is to clean up the changes and submit PRs to the parent repositories. 

# Getting Started

* this deployment runs on Ubuntu 18.04
* cif and the dependencies run in a python 3.6 venv
  * python 3.6 is the version shipped with Ubuntu 18.04
* this sets up the latest versions of cifv3 and dependencies
* this repo has integrated the csirtgadgets.cif Ansible role

## Todo

* VM amd Docker
  * fix sdist.yml (cif-ansible-role repo)
* Docker
  * run bootstrap tests

## Wontfix

* CentOS/RHEL support

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

  | env var | example value | info |
  | --- | --- | --- |
  | CIF_BOOTSTRAP_TEST | 1 | run bootstrap tests |
  | CIF_ANSIBLE_ES | 'localhost:9200' | install with Elastic backend |
  | CIF_ANSIBLE_SMRT_DB_PATH | '/new/path' | change smrt.db directory |
  | CIF_STORE_ES_UPSERT_MODE | 1 | ES upsert mode (use only with ES backend) |

## Docker

* Requirements: have docker and docker-compose installed

* build image (same for sqlite3 or ES backends)

      cd bearded-avenger-deploymentkit
      docker-compose build

* To use the sqlite backend:

      docker-compose up -d

* to use the Elastic backend:

      cp overrides/docker-compose.elasticsearch.yml docker-compose.override.yml
      docker-compose up -d

* get a shell on running container, switch to cif user, and test connectivity

      docker-compose exec cifv3 /bin/bash
      sudo -u cif -i
      cif -p

* optional build args to pull from private Github repo (see overrides/docker-compose.deploy_key.yml)


  | build arg | example value | info |
  | --- | --- | --- |
  | CIF_RELEASE_URL | git@github.com:yourorg/cifv3_code.git | ssh address for repo |
  | GITHUB_DEPLOY_KEY_FILE | /tmp/github_deploy_key | path for github deploy key in container |
  | GITHUB_DEPLOY_KEY_BASE64 | n/a | base64 encoded private ssh key |

* optional env vars

  | env var | example value | info |
  | --- | --- | --- |
  | CIF_TOKEN | n/a |cif admin token |
  | CIF_HUNTER_TOKEN | n/a |cif hunter token |
  | CIF_HTTPD_TOKEN | n/a | cif httpd token |
  | CSIRTG_SMRT_TOKEN | n/a | cif smrt token |
  | CIF_HTTPD_LISTEN | "0.0.0.0" | cif-httpd to listen externally (defaults to 127.0.0.1:5000) |
  | SERVICE_STOP_SMRT | 1 | prevent smrt service from running |
  | DOCKER_HTTPS | 1 | enable https |

  * DOCKER_HTTPS
    * if using the docker-compose.yml file, be sure to expose the https port
    * to override the self signed certificates, bind mount the correct certs
      at the following paths:

          ssl_certificate /etc/nginx/ssl/nginx.crt;
          ssl_certificate_key /etc/nginx/ssl/nginx.key;

  * see overrides/docker-compose.elasticsearch.yml for cif env vars for ES

---

[Original Wiki](https://github.com/csirtgadgets/bearded-avenger-deploymentkit/wiki)
