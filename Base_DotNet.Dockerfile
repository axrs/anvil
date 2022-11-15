ARG ANVIL_BASE_TAG
FROM axrs/anvil:$ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DOTNET_ROOT=/usr/dotnet
ENV PATH="$DOTNET_ROOT:${PATH}"
ARG DOTNET_VERSION

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt --quiet update \
 && apt --quiet --yes --no-install-recommends install \
    gnupg \
    libicu-dev

RUN echo '----- Azure Functions Core Tools' \
 && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg >/dev/null \
 && curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/microsoft-prod.list >/dev/null \
 && apt --quiet update \
 && apt --quiet --yes --no-install-recommends install \
    azure-functions-core-tools-4

RUN echo '----- DotNet Core' \
 && mkdir -p "$DOTNET_ROOT" \
 && curl -sL https://dot.net/v1/dotnet-install.sh -o "$DOTNET_ROOT/dotnet-install.sh" \
 && chmod u+x "$DOTNET_ROOT/dotnet-install.sh" \
 && "$DOTNET_ROOT/dotnet-install.sh" --install-dir "$DOTNET_ROOT" --version "$DOTNET_VERSION" \
 && echo "export PATH=$PATH" > /etc/environment \
 # Azure Artifacts Credential Provider
 && curl -fsSL https://aka.ms/install-artifacts-credprovider.sh

RUN echo '----- Verification' \
 && dotnet --list-sdks \
 && dotnet --list-runtimes \
 && func --version \
 && apt --quiet --yes clean \
 && apt --quiet --yes autoclean \
 && apt --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*
