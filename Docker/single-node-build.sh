#!/usr/bin/env sh

old_dc=$(which docker-compose > /dev/null; echo $?)

if [ $old_dc != 1 ]
then
  dc_exe="docker-compose"
else
  dc_exe="docker compose"
fi

# build and/or pull needed images
docker pull ubuntu:22.04

$dc_exe -f build-containers/docker-compose.yml build --progress plain cif-python

if [ -f ./secrets/docker-compose.deploy_key.yml ]
then
  echo "Private bearded-avenger build"
  $dc_exe -f build-containers/docker-compose.yml -f secrets/docker-compose.deploy_key.yml build --progress plain cif-build
else
  echo "Public bearded-avenger build"
  $dc_exe -f build-containers/docker-compose.yml build --progress plain cif-build
fi

$dc_exe -f docker-compose.yml build --progress plain cif
