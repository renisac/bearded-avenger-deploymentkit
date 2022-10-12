#!/bin/bash

set -e

if [ "$(whoami)" != 'root' ]; then
    echo "must be run as root"
    exit 1
fi

# Check for an Internet Connection as it is required during installation
HTTP_HOST=http://github.com
if [ -x "$(which wget)" ]; then
    echo "Checking for an Internet connection"
    if [[ "$(wget -q --tries=3 --timeout=10 --spider $HTTP_HOST)" -eq 0 ]]; then
        echo "$HTTP_HOST appears to be available via HTTP"
    else
        echo "$HTTP_HOST does not appear to be available via HTTP"
        echo "Exiting installation"
        exit 1
    fi
else
    echo "/usr/bin/wget does not exist, skipping Internet connection test"
fi

# archive old versions
bash archive_old_versions.sh

if [ -f /etc/lsb-release ]; then
    # shellcheck disable=SC1091
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    OS=Debian  # XXX or Ubuntu??
    VER=$(cat /etc/debian_version)
elif [ -f /etc/centos-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif [ -f /etc/redhat-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
else
    OS=$(uname -s)
    VER=$(uname -r)
fi

case $OS in
    "Ubuntu" )
        if [ "$VER" == "22.04" ]; then
            cd ./Ansible/ubuntu22
            bash bootstrap.sh
        else
            echo "Currently only 22.04 LTS (Server) is supported"
        fi;;
esac
