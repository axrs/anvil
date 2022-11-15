FROM debian:bullseye-slim
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG DART_VERSION

ENV DEBIAN_FRONTEND noninteractive

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
 && rm -rf /var/lib/apt/lists/* \
 && echo '----- Additional Package Repositories' \
 && echo '      -- Dart Package Repository' \
 && sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg' \
 && sh -c "echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list" \
 && echo '      -- Microsoft Powershell' \
 && curl -sL 'https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb' -o 'packages-microsoft-prod.deb' \
 && dpkg -i 'packages-microsoft-prod.deb' \
 && rm -f 'packages-microsoft-prod.deb' \
 && echo '---- Installs' \
 && apt-get --quiet update \
 && apt-get --quiet --yes --no-install-recommends install \
    dart="$DART_VERSION" \
    powershell \
 && rm -rf /var/lib/apt/lists/* \
 && echo '----- Build Cleanup' \
 && apt-get --quiet --purge --yes remove  \
    apt-transport-https \
    gnupg \
    unzip \
 && echo '----- Verification' \
 && dart --version \
 && pwsh --version \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*
