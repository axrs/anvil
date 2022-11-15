ARG ANVIL_BASE_TAG
FROM $ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG JAVA_VERSION
ARG CLOJURE_VERSION

## Add third party package repositories
RUN sh -c 'curl -sLk https://apt.corretto.aws/corretto.key | apt-key add -' \
 && echo 'deb https://apt.corretto.aws stable main' | tee /etc/apt/sources.list.d/awscorretto.list

## Install Tools/SDKs
RUN curl -sL "https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh" | bash \
 && apt-get --quiet update \
 && apt-get install -y --no-install-recommends \
    "java-$JAVA_VERSION-amazon-corretto-jdk" \
    leiningen \
    maven \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*

## Verify
RUN clojure --version \
 && java --version \
 && lein --version \
 && mvn --version