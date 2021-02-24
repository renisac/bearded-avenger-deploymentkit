#!/bin/bash

export CIF_STORE_ES_UPSERT_MODE=1
export CIF_ANSIBLE_ES='localhost:9200'
export CIF_BOOTSTRAP_TEST=1

/bin/bash ./easybutton.sh
