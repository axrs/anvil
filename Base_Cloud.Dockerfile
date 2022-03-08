ARG ANVIL_BASE_TAG="base"
FROM axrs/anvil:$ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
    python3 \
    python3-pip \

 && echo '----- Infrastructure CLIs' \
 && pip3 install --quiet --upgrade --no-cache-dir \
    pip-autoremove \
    awscli \
    azure-cli \
 && pip-autoremove --leaves -y \

 && echo '----- Build Cleanup' \
 && apt-get -q remove --purge -y \
    python3-pip \

 && echo '----- Verification' \
 && aws --version \
 && az --version \
 && az config set extension.use_dynamic_install=yes_without_prompt \
 && apt-get -q clean -y && apt-get -q autoclean -y && apt-get -q autoremove -y \
 && rm -rf /var/lib/apt/lists/*
