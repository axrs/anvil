FROM debian:bullseye-slim
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG DART_VERSION

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get --quiet --yes update \
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
 && echo '----- Additional Package Repositories' \
 && echo '      -- Dart Package Repository' \
 && sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg' \
 && sh -c "echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list" \
 && echo '      -- Microsoft' \
 && curl -sL 'https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb' -o 'packages-microsoft-prod.deb' \
 && dpkg -i 'packages-microsoft-prod.deb'

RUN echo '---- Installs' \
 && apt-get --quiet update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    dart="$DART_VERSION" \
    powershell \
 && curl -fsSL https://aka.ms/install-artifacts-credprovider.sh \
 && echo '----- Build Cleanup' \
 && apt-get --quiet --purge --yes remove  \
    apt-transport-https \
    gnupg \
    unzip

RUN echo '----- Verification' \
 && dart --version \
 && pwsh --version \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*
