ARG ANVIL_BASE_TAG
FROM axrs/anvil:$ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG JAVA_VERSION

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt --quiet update \
 && apt --quiet --yes --no-install-recommends install \
    gnupg

RUN echo '----- Additional Package Repositories' \
 && echo '      -- Java' \
 && sh -c 'curl -sLk https://apt.corretto.aws/corretto.key | apt-key add -' \
 && echo 'deb https://apt.corretto.aws stable main' | tee /etc/apt/sources.list.d/awscorretto.list

RUN echo '---- SDK Installs' \
 && apt --quiet update \
 && curl -sL 'https://download.clojure.org/install/linux-install-1.10.3.986.sh' | bash \
 && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    "java-$JAVA_VERSION-amazon-corretto-jdk" \
    leiningen \
    maven

RUN echo '----- Build Cleanup' \
 && apt --quiet --purge --yes remove  \
    gnupg \
 && echo '----- Verification' \
 && clojure --version \
 && java --version \
 && lein --version \
 && mvn --version \
 && apt --quiet --yes clean \
 && apt --quiet --yes autoclean \
 && apt --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*
