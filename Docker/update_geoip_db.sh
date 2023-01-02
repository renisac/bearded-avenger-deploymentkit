#!/bin/sh

BA_DIR=/srv/docker/bearded-avenger-deploymentkit

docker run \
  --rm \
  --env-file ./secrets/geoipupdate_env \
  -v ${BA_DIR}/Docker/geo_dbs:/usr/share/GeoIP \
  maxmindinc/geoipupdate
