#!/bin/sh

docker run \
  --rm \
  --env-file ./secrets/geoipupdate_env \
  -v ./scraps/geoip_dbs:/usr/share/GeoIP \
  ghcr.io/maxmind/geoipupdate
