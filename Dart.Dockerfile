FROM debian:bullseye-slim
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND noninteractive
ARG DART_VERSION

RUN apt-get --quiet --yes update \
 && apt-get --quiet --yes upgrade \
 && apt-get --quiet --yes --no-install-recommends install \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg \
    openssh-client \
    unzip \
    wget \
 && rm -rf /var/lib/apt/lists/*

## Add third party package repositories
RUN sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg' \
 && sh -c "echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list" \
 && curl -sL 'https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb' -o 'packages-microsoft-prod.deb' \
 && dpkg -i 'packages-microsoft-prod.deb' \
 && rm -f 'packages-microsoft-prod.deb'

## Install SDKs/Tools
RUN apt-get --quiet update \
 && apt-get --quiet --yes --no-install-recommends install \
    dart="$DART_VERSION" \
    powershell \
 && rm -rf /var/lib/apt/lists/*

## Cleanup
RUN apt-get --quiet --purge --yes remove  \
    apt-transport-https \
    unzip \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*

## Verify utilities
RUN dart --version \
 && pwsh --version