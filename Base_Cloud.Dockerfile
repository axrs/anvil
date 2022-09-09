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
    python3-venv

ENV PATH="/root/.local/bin:${PATH}"

RUN echo '----- Infrastructure CLIs' \
 && pip3 install --upgrade pipx \
 && python3 -m pipx ensurepath \
 && pipx install awscli \
 && pipx install azure-cli

RUN echo '----- Verification' \
 && aws --version \
 && az --version \
 && az \
 && az config set extension.use_dynamic_install=yes_without_prompt \
 && rm -rf /var/lib/apt/lists/*
