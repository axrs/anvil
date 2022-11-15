ARG ANVIL_BASE_TAG
FROM $ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

## Install Tools
RUN apt-get --quiet update \
 && apt-get --quiet --yes --no-install-recommends install \
    python3 \
    python3-pip \
    python3-venv \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/* \
 && pip3 install --no-cache-dir --upgrade pipx \
 && python3 -m pipx ensurepath

ENV PATH="/root/.local/bin:${PATH}"

## Install Cloud CLIs
RUN pipx install --system-site-packages --pip-args=--no-cache-dir awscli \
 && pipx install --system-site-packages --pip-args=--no-cache-dir azure-cli

## Verify utilities
RUN aws --version \
 && az --version \
 && az \
 && az config set extension.use_dynamic_install=yes_without_prompt