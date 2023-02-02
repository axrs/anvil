ARG ANVIL_BASE_TAG
FROM $ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DOTNET_ROOT=/usr/dotnet
ENV PATH="$DOTNET_ROOT:${PATH}"
ARG DOTNET_VERSION
