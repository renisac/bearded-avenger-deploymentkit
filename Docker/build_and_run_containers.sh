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

$dc_exe -f docker-compose.build_deps.yml build --progress plain cif-python

if [ -f ./secrets/docker-compose.deploy_key.yml ]
then
  $dc_exe -f docker-compose.build_deps.yml -f secrets/docker-compose.deploy_key.yml build --progress plain cif-build
else
  echo "public BA build"
  #docker-compose -f docker-compose.build_deps.yml build --progress plain cif-build
fi

$dc_exe -f docker-compose.yml build --progress plain cif
$dc_exe -f docker-compose.yml up
$dc_exe -f docker-compose.yml down

#docker-compose -f docker-compose.multi.yml build cif-router
#docker-compose -f docker-compose.multi.yml build cif-smrt
#docker-compose -f docker-compose.multi.yml pull proxy-es
#docker-compose -f docker-compose.multi.yml pull es01
#
## bring up service and display logs
#if [ -f ./scraps/docker-compose.override.yml ]
#then
#  docker-compose -f docker-compose.multi.yml -f ./scraps/docker-compose.override.yml up -d
#else
#  docker-compose -f docker-compose.multi.yml up -d
#fi
#
#docker-compose -f docker-compose.multi.yml logs -f
