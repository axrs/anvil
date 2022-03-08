FROM debian:bullseye-slim
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get --quiet --yes update \
 && apt-get --quiet --yes --no-install-recommends install \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg \
    openssh-client \
    unzip \
 && echo '----- Additional Package Repositories' \
 && echo '      -- Node.js' \
 && curl -sL 'https://deb.nodesource.com/setup_12.x' | bash \
 && echo '      -- Dart Package Repository' \
 && sh -c 'curl -sLk https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' \
 && sh -c 'curl -sLk https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list' \
 && echo '      -- Microsoft' \
 && curl -sL 'https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb' -o 'packages-microsoft-prod.deb' \
 && dpkg -i 'packages-microsoft-prod.deb' \
 && echo '---- Installs' \
 && apt-get --quiet update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    dart \
    nodejs \
    powershell \
 && curl -fsSL https://aka.ms/install-artifacts-credprovider.sh \
 && echo '----- Build Cleanup' \
 && apt-get --quiet --purge --yes remove  \
    apt-transport-https \
    curl \
    gnupg \
    unzip \
 && echo '----- Verification' \
 && dart --version \
 && node --version \
 && npm --version \
 && npx --version \
 && pwsh --version \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*
