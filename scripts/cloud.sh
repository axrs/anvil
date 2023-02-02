#!/usr/bin/env bash
set -euxo pipefail

apt-get --quiet update
apt-get --quiet --yes --no-install-recommends install \
	python3 \
	python3-pip \
	python3-venv
apt-get --quiet --yes clean
apt-get --quiet --yes autoclean
apt-get --quiet --yes autoremove
rm -rf /var/lib/apt/lists/*
pip3 install --no-cache-dir --upgrade pipx
python3 -m pipx ensurepath

## Install Cloud CLIs
pipx install --system-site-packages --pip-args=--no-cache-dir awscli
pipx install --system-site-packages --pip-args=--no-cache-dir azure-cli

## Verify utilities
aws --version
az --version
az
az config set extension.use_dynamic_install=yes_without_prompt
