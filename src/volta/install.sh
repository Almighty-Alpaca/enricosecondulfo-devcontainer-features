#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

set -eu
set -x

source /etc/os-release
source utils.sh

cleanup

check_packages curl ca-certificates jq

VOLTA_VERSION=${VOLTA_VERSION:-latest}

VOLTA_URL="$(curl -sL "https://api.github.com/repos/volta-cli/volta/releases/${VOLTA_VERSION}" | jq -r '.assets[] | select(.name | endswith("-linux.tar.gz")) | .browser_download_url')"

echo "Installing Volta ${VOLTA_VERSION} from ${VOLTA_URL}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

mkdir -p /opt/volta/bin
curl -L "${VOLTA_URL}" | tar zx -C /opt/volta/bin

echo "export VOLTA_HOME=\"${HOME}/.volta\"" >> /etc/profile.d/50-volta.sh
echo "export PATH=\"/opt/volta/bin/:\$VOLTA_HOME/bin:\$PATH\"" >> /etc/profile.d/50-volta.sh
