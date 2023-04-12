#!/usr/bin/env sh

# build and/or pull needed images
docker pull ubuntu:22.04

docker-compose -f docker-compose.build_deps.yml build cif-python
if [ -f ./secrets/docker-compose.deploy_key.yml ]
then
  docker-compose -f docker-compose.build_deps.yml -f secrets/docker-compose.deploy_key.yml build cif-base
else
  docker-compose -f docker-compose.build_deps.yml build cif-base
fi

docker-compose -f docker-compose.multi.yml build cif-router
docker-compose -f docker-compose.multi.yml build cif-smrt
docker-compose -f docker-compose.multi.yml pull proxy-es
docker-compose -f docker-compose.multi.yml pull es01

# bring up service and display logs
if [ -f ./scraps/docker-compose.override.yml ]
then
  docker-compose -f docker-compose.multi.yml -f ./scraps/docker-compose.override.yml up -d
else
  docker-compose -f docker-compose.multi.yml up -d
fi

docker-compose -f docker-compose.multi.yml logs -f
