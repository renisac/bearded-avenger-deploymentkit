#!/command/with-contenv sh

if [ ! -z ${CIF_STORE_NODES} ]
then
  echo ""
  echo "skip 10"
  echo ""
  exit 0
fi

if [ ! -f /var/lib/cif/cif.db ]
then
  mkdir -p /var/lib/cif
  touch /var/lib/cif/cif.db
  chown cif:cif /var/lib/cif/cif.db
  chmod 0660 /var/lib/cif/cif.db
  cat /tmp/cif_schema.db | sqlite3 /var/lib/cif/cif.db
fi

rm -f /tmp/cif_schema.db

CIF_TOKEN="${CIF_TOKEN}"
CIF_HUNTER_TOKEN="${CIF_HUNTER_TOKEN}"
CSIRTG_SMRT_TOKEN="${CSIRTG_SMRT_TOKEN}"
CIF_HTTPD_TOKEN="${CIF_HTTPD_TOKEN}"

if [ -n "${CIF_TOKEN}" ]
then
  echo ""
  echo "setting admin token"
  echo "---" > /home/cif/.cif.yml
  echo "token: ${CIF_TOKEN}" >> /home/cif/.cif.yml
  chown cif:cif /home/cif/.cif.yml
  chmod 0640 /home/cif/.cif.yml
  sqlite3 /var/lib/cif/cif.db "UPDATE tokens SET token = \"${CIF_TOKEN}\" WHERE username = 'admin';" ".exit"
fi

if [ -n "${CIF_HUNTER_TOKEN}" ]
then
  echo ""
  echo "setting hunter token"
  echo "---" > /etc/cif/cif-router.yml
  echo "hunter_token: ${CIF_HUNTER_TOKEN}" >> /etc/cif/cif-router.yml
  echo "" >> /etc/cif/cif-router.yml
  chown cif:cif /etc/cif/cif-router.yml
  chmod 0640 /etc/cif/cif-router.yml
  sqlite3 /var/lib/cif/cif.db "UPDATE tokens SET token = \"${CIF_HUNTER_TOKEN}\" WHERE username = 'hunter';" ".exit"
fi

if [ -n "${CSIRTG_SMRT_TOKEN}" ]
then
  echo ""
  echo "setting smrt token"
  echo "---" > /etc/cif/csirtg-smrt.yml
  echo "token: ${CSIRTG_SMRT_TOKEN}" >> /etc/cif/csirtg-smrt.yml
  chown cif:cif /etc/cif/csirtg-smrt.yml
  chmod 0640 /etc/cif/csirtg-smrt.yml
  sqlite3 /var/lib/cif/cif.db "UPDATE tokens SET token = \"${CSIRTG_SMRT_TOKEN}\" WHERE username = 'csirtg-smrt';" ".exit"
  #sqlite3 /var/lib/cif/cif.db "INSERT INTO tokens (username,token) VALUES('csirtg-smrt',\"${CSIRTG_SMRT_TOKEN}\");" ".exit"
fi

if [ -n "${CIF_HTTPD_TOKEN}" ]
then
  echo ""
  echo "setting httpd token"
  sqlite3 /var/lib/cif/cif.db "INSERT INTO tokens (username,token) VALUES('httpd',\"${CIF_HTTPD_TOKEN}\");" ".exit"
fi

echo ""
