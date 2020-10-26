#!/usr/bin/with-contenv bash

CIF_TOKEN="${CIF_TOKEN}"
CIF_HUNTER_TOKEN="${CIF_HUNTER_TOKEN}"
CSIRTG_SMRT_TOKEN="${CSIRTG_SMRT_TOKEN}"

if [ -n "${CIF_TOKEN}" ]
then
  echo "token: ${CIF_TOKEN}" > /home/cif/.cif.yml
  sqlite3 /var/lib/cif/cif.db "UPDATE tokens SET token = \"${CIF_TOKEN}\" WHERE username = 'admin';" ".exit"
fi

if [ -n "${CIF_HUNTER_TOKEN}" ]
then
  echo "hunter_token: ${CIF_HUNTER_TOKEN}" > /etc/cif/cif-router.yml
  sqlite3 /var/lib/cif/cif.db "UPDATE tokens SET token = \"${CIF_HUNTER_TOKEN}\" WHERE username = 'hunter';" ".exit"
fi

if [ -n "${CSIRTG_SMRT_TOKEN}" ]
then
  echo "token: ${CSIRTG_SMRT_TOKEN}" > /etc/cif/csirtg-smrt.yml
  sqlite3 /var/lib/cif/cif.db "UPDATE tokens SET token = \"${CSIRTG_SMRT_TOKEN}\" WHERE username = 'csirtg-smrt';" ".exit"
fi

