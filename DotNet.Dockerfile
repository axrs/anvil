ARG ANVIL_BASE_TAG
FROM $ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DOTNET_ROOT=/usr/dotnet
ENV PATH="$DOTNET_ROOT:${PATH}"
ARG DOTNET_VERSION

## Add third party package repositories
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg >/dev/null \
 && curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/microsoft-prod.list >/dev/null

## Install Tools/SDKs
RUN apt-get --quiet update \
 && apt-get --quiet --yes --no-install-recommends install \
    azure-functions-core-tools-4 \
    libicu-dev \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*

## Install DotNet
RUN mkdir -p "$DOTNET_ROOT" \
 && curl -sL https://dot.net/v1/dotnet-install.sh -o "$DOTNET_ROOT/dotnet-install.sh" \
 && chmod u+x "$DOTNET_ROOT/dotnet-install.sh" \
 && "$DOTNET_ROOT/dotnet-install.sh" --install-dir "$DOTNET_ROOT" --version "$DOTNET_VERSION" \
 && echo "export PATH=$PATH" > /etc/environment

## Install Azure Artifacts Credential Provider
RUN curl -sL https://aka.ms/install-artifacts-credprovider.sh | bash

## Verify
RUN dotnet --list-sdks \
 && dotnet --list-runtimes \
 && func --version
 ### TODO Verify Credential Provider installed