#!/usr/bin/env bash
set -euxo pipefail

sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg'
sh -c "echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list"

## Install SDKs/Tools
apt-get --quiet update
apt-get --quiet --yes --no-install-recommends install dart="$DART_VERSION"
rm -rf /var/lib/apt/lists/*

## Cleanup
apt-get --quiet --yes clean
apt-get --quiet --yes autoclean
apt-get --quiet --yes autoremove
rm -rf /var/lib/apt/lists/*

## Verify utilities
dart --version
