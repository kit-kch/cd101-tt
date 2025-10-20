#!/bin/bash

OSSCAD_VERSION="2025-01-15"


export DEBIAN_FRONTEND=noninteractive
apt-get update -qq -y
apt-get -qq -y install curl git sudo build-essential locales
apt-get clean

dpkg-reconfigure --frontend=noninteractive locales 
update-locale LANG=en_US.UTF-8

cd /opt
OSSCAD_VERSION_SHORT=$(echo "${OSSCAD_VERSION}" | sed 's/-//g')
curl --progress-bar -L "https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSSCAD_VERSION}/oss-cad-suite-linux-x64-${OSSCAD_VERSION_SHORT}.tgz" -o osscad.tgz
tar -xf osscad.tgz
rm osscad.tgz
echo "${OSSCAD_VERSION}" > /opt/oss-cad-suite/VERSION
echo "source /opt/oss-cad-suite/environment" > /etc/profile.d/z99_oss_cad_suite.sh