#!/usr/bin/env bash
set -euxo pipefail

apt-get --quiet clean
apt-get --quiet --yes update
apt-get --quiet --yes upgrade
apt-get --quiet --yes --no-install-recommends install \
	apt-transport-https \
	ca-certificates \
	curl \
	git \
	gnupg \
	openssh-client \
	unzip \
	wget
rm -rf /var/lib/apt/lists/*

## Add third party package repositories
curl -sL 'https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb' -o 'packages-microsoft-prod.deb'
dpkg -i 'packages-microsoft-prod.deb'
rm -f 'packages-microsoft-prod.deb'

## Install SDKs/Tools
apt-get --quiet update
apt-get --quiet --yes --no-install-recommends install powershell
rm -rf /var/lib/apt/lists/*

apt-get --quiet --yes clean
apt-get --quiet --yes autoclean
apt-get --quiet --yes autoremove
rm -rf /var/lib/apt/lists/*

## Verify utilities
pwsh --version
