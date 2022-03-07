FROM debian:bullseye-slim
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
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
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    dart \
    nodejs \
    powershell \

 && echo '----- Build Cleanup' \
 && apt-get -q remove --purge -y \
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
 && apt-get -q clean -y && apt-get -q autoclean -y && apt-get -q autoremove -y \
 && rm -rf /var/lib/apt/lists/*
