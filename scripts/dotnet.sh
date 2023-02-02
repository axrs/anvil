#!/usr/bin/env bash
set -euxo pipefail

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg >/dev/null
curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/microsoft-prod.list >/dev/null

## Install Tools/SDKs
apt-get --quiet update
apt-get --quiet --yes --no-install-recommends install \
	azure-functions-core-tools-4 \
	libicu-dev
apt-get --quiet --yes clean
apt-get --quiet --yes autoclean
apt-get --quiet --yes autoremove
rm -rf /var/lib/apt/lists/*

## Install DotNet
mkdir -p "$DOTNET_ROOT"
curl -sL https://dot.net/v1/dotnet-install.sh -o "$DOTNET_ROOT/dotnet-install.sh"
chmod u+x "$DOTNET_ROOT/dotnet-install.sh"
"$DOTNET_ROOT/dotnet-install.sh" --install-dir "$DOTNET_ROOT" --version "$DOTNET_VERSION"
echo "export PATH=$PATH" >/etc/environment

## Install Azure Artifacts Credential Provider
curl -sL https://aka.ms/install-artifacts-credprovider.sh | bash

## Verify
dotnet --list-sdks
dotnet --list-runtimes
func --version
### TODO Verify Credential Provider installed
