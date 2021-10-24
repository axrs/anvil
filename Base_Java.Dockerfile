ARG ANVIL_BASE_TAG="base"
FROM axrs/anvil:$ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
    curl \
    gnupg \

 && echo '----- Additional Package Repositories' \
 && echo '      -- Java' \
 && sh -c 'curl -sLk https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -' \
 && echo 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb bullseye main' | tee /etc/apt/sources.list.d/adoptopenjdk.list \

 && echo '---- SDK Installs' \
 && apt-get -q update \
 && curl -sL 'https://download.clojure.org/install/linux-install-1.10.3.986.sh' | bash \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    adoptopenjdk-15-hotspot \
    leiningen \
    maven \

 && echo '----- Build Cleanup' \
 && apt-get -q remove --purge -y \
    curl \
    gnupg \

 && echo '----- Verification' \
 && clojure --version \
 && java --version \
 && lein --version \
 && mvn --version \
 && apt-get -q clean -y && apt-get -q autoclean -y && apt-get -q autoremove -y \
 && rm -rf /var/lib/apt/lists/*
