ARG ANVIL_BASE_TAG="base"
FROM axrs/anvil:$ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DOTNET_ROOT=/usr/dotnet
ENV PATH="$DOTNET_ROOT:${PATH}"

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get --quiet update \
 && apt-get --quiet --yes --no-install-recommends install \
    gnupg \
    libicu-dev \
 && echo '----- Azure Functions Core Tools' \
 && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg >/dev/null \
 && curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/microsoft-prod.list >/dev/null \
 && apt-get --quiet update \
 && apt-get --quiet --yes --no-install-recommends install \
    azure-functions-core-tools-4 \
 && echo '----- DotNet Core' \
 && mkdir -p "$DOTNET_ROOT" \
 && curl -sL https://dot.net/v1/dotnet-install.sh -o "$DOTNET_ROOT/dotnet-install.sh" \
 && chmod u+x "$DOTNET_ROOT/dotnet-install.sh" \
 && "$DOTNET_ROOT/dotnet-install.sh" --install-dir "$DOTNET_ROOT" -c current \
 && echo "export PATH=$PATH" > /etc/environment \
 && echo '----- Verification' \
 && dotnet --list-sdks \
 && dotnet --list-runtimes \
 && func --version \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*
