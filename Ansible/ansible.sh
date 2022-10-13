#!/bin/bash

set -e

ansible-galaxy install elastic.elasticsearch,5.5.1

echo 'running ansible...'
ansible-playbook -i "localhost," -c local site.yml -vv
