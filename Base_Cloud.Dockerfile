ARG ANVIL_BASE_TAG="base"
FROM axrs/anvil:$ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get --quiet update \
 && apt-get --quiet --yes --no-install-recommends install \
    python3 \
    python3-pip \
 && echo '----- Infrastructure CLIs' \
 && pip3 install --quiet --upgrade --no-cache-dir \
    pip-autoremove \
    awscli \
    azure-cli \
 && pip-autoremove --leaves -y \
 && echo '----- Build Cleanup' \
 && apt-get --quiet --purge --yes remove  \
    python3-pip \
 && echo '----- Verification' \
 && aws --version \
 && az --version \
 && az config set extension.use_dynamic_install=yes_without_prompt \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*
