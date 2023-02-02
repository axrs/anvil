#!/usr/bin/env bash
set -euxo pipefail

## Install Tools/SDKs
curl -sL "https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh" | bash
apt-get --quiet update
apt-get install -y --no-install-recommends leiningen
apt-get --quiet --yes clean
apt-get --quiet --yes autoclean
apt-get --quiet --yes autoremove
rm -rf /var/lib/apt/lists/*

## Verify
clojure --version
lein --version
