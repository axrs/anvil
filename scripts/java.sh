#!/usr/bin/env bash
set -euxo pipefail

sh -c 'curl -sLk https://apt.corretto.aws/corretto.key | apt-key add -'
echo 'deb https://apt.corretto.aws stable main' | tee /etc/apt/sources.list.d/awscorretto.list

## Install Tools/SDKs
apt-get --quiet update
apt-get install -y --no-install-recommends \
	"java-$JAVA_VERSION-amazon-corretto-jdk" \
	maven
apt-get --quiet --yes clean
apt-get --quiet --yes autoclean
apt-get --quiet --yes autoremove
rm -rf /var/lib/apt/lists/*

## Verify
java --version
mvn --version
