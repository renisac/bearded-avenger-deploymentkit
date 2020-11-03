#!/usr/bin/with-contenv bash

if [ ! -z ${CIF_STORE_NODES} ]
then
  echo ""
  echo "skip 01"
  echo ""
  exit 0
fi

CIF_TOKEN="${CIF_TOKEN}"
CIF_HUNTER_TOKEN="${CIF_HUNTER_TOKEN}"
CSIRTG_SMRT_TOKEN="${CSIRTG_SMRT_TOKEN}"

if [ -n "${CIF_TOKEN}" ]
then
  echo "---" > /home/cif/.cif.yml
  echo "token: ${CIF_TOKEN}" >> /home/cif/.cif.yml
  sqlite3 /var/lib/cif/cif.db "UPDATE tokens SET token = \"${CIF_TOKEN}\" WHERE username = 'admin';" ".exit"
fi

if [ -n "${CIF_HUNTER_TOKEN}" ]
then
  echo "---" > /etc/cif/cif-router.yml
  echo "hunter_token: ${CIF_HUNTER_TOKEN}" >> /etc/cif/cif-router.yml
  sqlite3 /var/lib/cif/cif.db "UPDATE tokens SET token = \"${CIF_HUNTER_TOKEN}\" WHERE username = 'hunter';" ".exit"
fi

if [ -n "${CSIRTG_SMRT_TOKEN}" ]
then
  echo "---" > /etc/cif/csirtg-smrt.yml
  echo "token: ${CSIRTG_SMRT_TOKEN}" >> /etc/cif/csirtg-smrt.yml
  sqlite3 /var/lib/cif/cif.db "UPDATE tokens SET token = \"${CSIRTG_SMRT_TOKEN}\" WHERE username = 'csirtg-smrt';" ".exit"
fi

if [ -n "${CIF_HTTPD_TOKEN}" ]
then
#  echo "---" > /etc/cif/csirtg-smrt.yml
#  echo "token: ${CSIRTG_SMRT_TOKEN}" >> /etc/cif/csirtg-smrt.yml
#  sqlite3 /var/lib/cif/cif.db "UPDATE tokens SET token = \"${CIF_HTTPD_TOKEN}\" WHERE EXISTS username = 'httpd';" ".exit"
  sqlite3 /var/lib/cif/cif.db "INSERT INTO token (username,token) VALUES('httpd',\"${CIF_HTTPD_TOKEN}\");" ".exit"
fi

