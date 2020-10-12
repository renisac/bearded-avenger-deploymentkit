# Getting Started

## NOTES:

* this sets up the latest versions of cifv3 and dependencies
* cif and the dependencies run in a python 3.5 venv
* Currently only Ubuntu 16.04 is supported

## Installation

* do all this as root

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

## Todo

---

[See the Wiki...](https://github.com/csirtgadgets/bearded-avenger-deploymentkit/wiki)
