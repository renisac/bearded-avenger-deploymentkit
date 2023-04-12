# SES Docker WIP

## Setup

* clone repo locally

### GeoIP setup

* create file Docker/secrets/geoioupdate_env
  * get creds from 1Password or use your own

```
# https://hub.docker.com/r/maxmindinc/geoipupdate

GEOIPUPDATE_ACCOUNT_ID=
GEOIPUPDATE_LICENSE_KEY=
GEOIPUPDATE_EDITION_IDS=GeoLite2-ASN GeoLite2-City
```

* pull GeoIP docker image
```
docker pull ghcr.io/maxmind/geoipupdate
```

* download geoip dbs. change path before running
```
docker run \
  --rm \
  --env-file ./secrets/geoipupdate_env \
  -v ./scraps/geoip_dbs:/usr/share/GeoIP \
  ghcr.io/maxmind/geoipupdate
```

### Build images

* copy sesv4_code repo into Docker/cif-base/repos/
* build python image, build cif base, pull elastic, build smrt and router images

```
cd Docker
docker-compose -f docker-compose.build.yml build cif-python
docker-compose -f docker-compose.build.yml build cif-base
docker-compose pull es01
docker-compose build cif-router cif-smrt
```

## Running

* bring up elastic, httpd/router, and smrt
```
docker-compose up -d
```

### misc

* expose httpd and/or elastic ports in docker-compose.yml
* ES data in "es_data" Docker volume
* smrt startup delayed one minute instead of 5
  * can revert after testing is done

## Todo

* figure out values for defaults if different from code default
* figure out which code env vars we want/need to pass from container start to the application.
