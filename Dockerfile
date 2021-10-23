FROM debian:bullseye-slim
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG CLOJURE_VERSION='1.10.3.986'
ARG JABBA_JAVA_VERSION='adopt@1.15.0-2'
ENV JAVA_HOME /jdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV PATH /n/bin:$PATH

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    apt-transport-https \
    curl \
    build-essential \
    git \
    gnupg \
    openssh-client \
    python3 \
    python3-pip \
    rlwrap \
    unzip \
    wget \
 && curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | JABBA_COMMAND="install $JABBA_JAVA_VERSION -o /jdk" bash \
 && curl -sL "https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh" | bash \
 && curl -sL https://git.io/n-install | N_PREFIX=/n bash -s -- -y \
 && sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' \
 && sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list' \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    dart \
    leiningen \
 && clj --version \
 && clojure --version \
 && dart --version \
 && java --version \
 && lein --version \
 && n lts \
 && node --version \
 && npm --version \
 && npx --version \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install the AWS and Azure CLIs
RUN pip3 install awscli azure-cli --upgrade \
 && aws --version \
 && az --version \
 && az config set extension.use_dynamic_install=yes_without_prompt
