#!/usr/bin/with-contenv bash

if [ -z "${DOCKER_HTTPS}" ]
then
  exit 0
fi

if [ -e /var/log/nginx/access.log ]
then
  rm -f /var/log/nginx/access.log
fi

ln -s /dev/stdout /var/log/nginx/access.log

if [ -e /var/log/nginx/error.log ]
then
  rm -f /var/log/nginx/error.log
fi

ln -s /dev/stdout /var/log/nginx/error.log
