#!/command/with-contenv bash

if [ -z ${CIF_STORE_NODES} ]
then
  echo ""
  echo "skip 99"
  echo ""
  exit 0
fi

# stop cif-store config file read errors
touch /etc/cif/cif-router.yml

until curl --silent --fail "http://${CIF_STORE_NODES}/_cluster/health?wait_for_status=yellow&timeout=180s"; do
  echo "Waiting for ${CIF_STORE_NODES} to be up"
  sleep 5
done

# if tokens index exists, this is not a fresh CIF instance, so wait on index shards to be available
status_code=$(curl --silent --head --write-out '%{http_code}' --output /dev/null "http://${CIF_STORE_NODES}/tokens/")

if [[ $status_code == 200 ]]; then
  until curl --silent --fail "http://${CIF_STORE_NODES}/tokens/_search"; do
    echo "Waiting for http://${CIF_STORE_NODES}/tokens/_search to be up"
    sleep 5
  done
else
  echo ""
  echo "Setting up tokens on fresh CIFv3 instance"
  rm -f /var/lib/cif/cif.db

  if [ -z ${CIF_TOKEN} ]
  then
    CIF_TOKEN=$(openssl rand -hex 40 | cut -c 1-80)
  fi

  echo ""
  echo "set admin token"
  echo "---" > /home/cif/.cif.yml
  echo "token: ${CIF_TOKEN}" >> /home/cif/.cif.yml
  chown cif:cif /home/cif/.cif.yml
  chmod 0640 /home/cif/.cif.yml
  /cif_venv/bin/cif-store -d --store elasticsearch --nodes ${CIF_STORE_NODES} \
    --token-create-admin --token ${CIF_TOKEN} --token-groups everyone

  if [ -z ${CIF_HUNTER_TOKEN} ]
  then
    CIF_HUNTER_TOKEN=$(openssl rand -hex 40 | cut -c 1-80)
  fi

  echo ""
  echo "set hunter token"
  echo "---" > /etc/cif/cif-router.yml
  echo "hunter_token: ${CIF_HUNTER_TOKEN}" >> /etc/cif/cif-router.yml
  chown cif:cif /etc/cif/cif-router.yml
  chmod 0640 /etc/cif/cif-router.yml
  /cif_venv/bin/cif-store -d --store elasticsearch --nodes ${CIF_STORE_NODES} \
    --token-create-hunter --token ${CIF_HUNTER_TOKEN} --token-groups everyone

  if [ -z ${CSIRTG_SMRT_TOKEN} ]
  then
    CSIRTG_SMRT_TOKEN=$(openssl rand -hex 40 | cut -c 1-80)
  fi

  echo ""
  echo "set smrt token in ES"
#  echo "---" > /etc/cif/csirtg-smrt.yml
#  echo "token: ${CSIRTG_SMRT_TOKEN}" >> /etc/cif/csirtg-smrt.yml
#  chown cif:cif /etc/cif/csirtg-smrt.yml
#  chmod 0640 /etc/cif/csirtg-smrt.yml
  /cif_venv/bin/cif-store -d --store elasticsearch --nodes ${CIF_STORE_NODES} \
    --token-create-smrt --token ${CSIRTG_SMRT_TOKEN} --token-groups everyone
  echo ""

  if [ -z ${CIF_HTTPD_TOKEN} ]
  then
    CIF_HTTPD_TOKEN=$(openssl rand -hex 40 | cut -c 1-80)
  fi

  echo ""
  echo "set httpd token in ES"
  /cif_venv/bin/cif-store -d --store elasticsearch --nodes ${CIF_STORE_NODES} \
    --token-create-httpd --token ${CIF_HTTPD_TOKEN} --token-groups everyone
fi
