ARG ANVIL_BASE_TAG="base"
FROM axrs/anvil:$ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get --quiet update \
 && apt-get --quiet --yes --no-install-recommends install \
    gnupg \
 && echo '----- Additional Package Repositories' \
 && echo '      -- Java' \
 && sh -c 'curl -sLk https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -' \
 && echo 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb bullseye main' | tee /etc/apt/sources.list.d/adoptopenjdk.list \
 && echo '---- SDK Installs' \
 && apt-get --quiet update \
 && curl -sL 'https://download.clojure.org/install/linux-install-1.10.3.986.sh' | bash \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    adoptopenjdk-15-hotspot \
    leiningen \
    maven \
 && echo '----- Build Cleanup' \
 && apt-get --quiet --purge --yes remove  \
    gnupg \
 && echo '----- Verification' \
 && clojure --version \
 && java --version \
 && lein --version \
 && mvn --version \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*
