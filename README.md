# Notice

This is a fork of the archived [CSIRT Gadgets bearded-avenger-deploymentkit repository](https://github.com/csirtgadgets/bearded-avenger-deploymentkit)

## General Information

* this deployment runs on Ubuntu 22.04
* cif and the dependencies run in a python 3.9 venv
  * python 3.9 comes from the deadsnakes ppa
* this sets up the latest versions of cifv3 and dependencies
* this repo has integrated the csirtgadgets.cif Ansible role

## Docker quick start

* To enable smrt feed downloads, comment out this env var in Docker/docker-compose.yml
    * ```SMRT_SERVICE_ENABLE```
* Build and run

        cd Docker
        bash ./single-node-build.sh
        docker compose up -d

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

### Requirements

* have docker and docker-compose installed

### Single node

This brings up a CIF container, an Elastic container, and a Kibana container

* Go to the Docker directory
    * ```cd Docker/```
* Build the cif image (and it's base containers)
    * ```bash ./single-node-build.sh```
* Bring up the environment
    *  ```docker compose up -d```

The following services are exposed by default from the docker-compose.yml file:

* CIF: http://127.0.0.1:5000
* Kibana: http://127.0.0.1:5601
* Elastic: http://127.0.0.1:9200

The default docker-compose.yml disables the smrt service (which downloads feeds). To enable the service,
either comment out the ```SMRT_SERVICE_ENABLE``` or override it with ```SMRT_SERVICE_ENABLE=1```

### Geoip database

You will need a valid Maxmind account to download the GeoIP2 or GeoLite2 databases.

* Copy the env template for the geoipupdate container
    * ```cp Docker/secrets/geoipupdate_env.example Docker/secrets/geoipupdate_env```
* U pdate geoipupdate_env with your Maxmind credentials
* Run the geoipupdate container to download the files
    * ```cd Docker && bash ./update_geoip_db.sh```
* Database files can be found here:
    * ```Docker/scraps/geo_ips```

### Multiple nodes

This deploys CIF services across multiple containers and mimics a potential production deployment.

* In Progress

### Common tasks

* Start a shell on running container, switch to cif user, and test connectivity

      docker compose exec cif /bin/bash
      sudo -u cif -i
      cif -p

* optional build args to pull from private Github repo

  | build arg | example value | info |
  | --- | --- | --- |
  | CIF_RELEASE_URL | git@github.com:yourorg/cifv3_code.git | ssh address for custom, cifv3 repo. if not specified uses default  [cifv3 repo](https://github.com/renisac/bearded-avenger/) |
  | GITHUB_DEPLOY_KEY_FILE | /tmp/github_deploy_key | path for github deploy key in container |
  | GITHUB_DEPLOY_KEY_BASE64 | n/a | base64 encoded private ssh key |

* optional env vars

  | env var | default value | info |
  | --- | --- | --- |
  | CIF_TOKEN | n/a |cif admin token |
  | CIF_HUNTER_TOKEN | n/a |cif hunter token |
  | CIF_HTTPD_TOKEN | n/a | cif httpd token |
  | CSIRTG_SMRT_TOKEN | n/a | cif smrt token |
  | CIF_HTTPD_LISTEN | "0.0.0.0" | cif-httpd to listen externally (defaults to 127.0.0.1:5000) |
  | SMRT_SERVICE_ENABLE | 1 | enable smrt service |

## Wontfix

* CentOS/RHEL support

---

[Original Wiki](https://github.com/csirtgadgets/bearded-avenger-deploymentkit/wiki)
[Forked Wiki](https://github.com/renisac/bearded-avenger-deploymentkit/wiki)
