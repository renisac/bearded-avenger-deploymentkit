#!/usr/bin/env sh

# build and/or pull needed images

cd ./Docker || exit 1

docker pull ubuntu:22.04

docker-compose -f docker-compose.build_deps.yml build cif-python
docker-compose -f docker-compose.build_deps.yml build cif-base

docker-compose -f docker-compose.yml build cif-router
docker-compose -f docker-compose.yml build cif-smrt

docker-compose -f docker-compose.yml pull proxy-es
docker-compose -f docker-compose.yml pull es01

docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d

docker-compose -f docker-compose.yml logs -f
