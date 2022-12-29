#!/bin/sh

docker run \
  --rm \
  --env-file ./secrets/geoipupdate_env \
  -v /srv/docker/RIDEV/bearded-avenger-deploymentkit/Docker/geo_dbs:/usr/share/GeoIP \
  maxmindinc/geoipupdate
