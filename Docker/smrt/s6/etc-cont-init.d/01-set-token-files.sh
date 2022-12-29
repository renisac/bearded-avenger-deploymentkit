#!/command/with-contenv sh

CIF_TOKEN="${CIF_TOKEN}"
CSIRTG_SMRT_TOKEN="${CSIRTG_SMRT_TOKEN}"

if [ -n "${CIF_TOKEN}" ]
then
  echo ""
  echo "set admin token"
  echo "---" > /home/cif/.cif.yml
  echo "token: ${CIF_TOKEN}" >> /home/cif/.cif.yml
  chown cif:cif /home/cif/.cif.yml
  chmod 0640 /home/cif/.cif.yml
fi

if [ -n "${CSIRTG_SMRT_TOKEN}" ]
then
  echo ""
  echo "set smrt token"
  echo "---" > /etc/cif/csirtg-smrt.yml
  echo "token: ${CSIRTG_SMRT_TOKEN}" >> /etc/cif/csirtg-smrt.yml
  chown cif:cif /etc/cif/csirtg-smrt.yml
  chmod 0640 /etc/cif/csirtg-smrt.yml
fi

echo ""
