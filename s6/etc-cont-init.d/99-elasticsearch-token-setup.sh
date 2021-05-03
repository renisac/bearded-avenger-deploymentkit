#!/usr/bin/with-contenv bash

if [ -z ${CIF_STORE_NODES} ]
then
  echo ""
  echo "skip 99"
  echo ""
  exit 0
fi

until curl -s "http://${CIF_STORE_NODES}/_cluster/health"; do
    echo "Waiting for ${CIF_STORE_NODES} to be up"
    sleep 5
done

rm -f /var/lib/cif/cif.db

echo ""
echo "set admin token"
echo "---" > /home/cif/.cif.yml
echo "token: ${CIF_TOKEN}" >> /home/cif/.cif.yml
/cif_venv/bin/cif-store -d --store elasticsearch --nodes ${CIF_STORE_NODES} \
  --token-create-admin --token ${CIF_TOKEN} --token-groups everyone

echo ""
echo "set hunter token"
echo "---" > /etc/cif/cif-router.yml
echo "hunter_token: ${CIF_HUNTER_TOKEN}" >> /etc/cif/cif-router.yml
/cif_venv/bin/cif-store -d --store elasticsearch --nodes ${CIF_STORE_NODES} \
  --token-create-hunter --token ${CIF_HUNTER_TOKEN} --token-groups everyone

echo ""
echo "set smrt token"
echo "---" > /etc/cif/csirtg-smrt.yml
echo "token: ${CSIRTG_SMRT_TOKEN}" >> /etc/cif/csirtg-smrt.yml
/cif_venv/bin/cif-store -d --store elasticsearch --nodes ${CIF_STORE_NODES} \
  --token-create-smrt --token ${CSIRTG_SMRT_TOKEN} --token-groups everyone
echo ""

echo ""
echo "set httpd token in ES"
/cif_venv/bin/cif-store -d --store elasticsearch --nodes ${CIF_STORE_NODES} \
  --token-create-httpd --token ${CIF_HTTPD_TOKEN} --token-groups everyone

