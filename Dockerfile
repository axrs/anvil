FROM debian:bullseye-slim
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"

RUN apt-get update
RUN apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    openssh-client \
    unzip \
    wget
RUN apt-get upgrade -y

# Install the AWS CLI
RUN pip3 install awscli --upgrade
RUN aws --version

# Install the Azure CLI
RUN pip3 install azure-cli --upgrade
RUN az --version
RUN az config set extension.use_dynamic_install=yes_without_prompt

# Install the latest Stable Dart SDK
RUN apt-get install -y apt-transport-https
RUN sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
RUN sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt-get update
RUN apt-get install dart
RUN dart --version

# Install Java via Jabba
ARG JABBA_JAVA_VERSION='adopt@1.15.0-2'
RUN curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | \
        JABBA_COMMAND="install $JABBA_JAVA_VERSION -o /jdk" bash
ENV JAVA_HOME /jdk
ENV PATH $JAVA_HOME/bin:$PATH
RUN java --version

# Install Clojure and Leiningen
ARG CLOJURE_VERSION='1.10.3.986'
RUN curl -sL "https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh" | bash
RUN apt-get install -y rlwrap leiningen
RUN clojure --version
RUN clj --version
RUN lein --version

# Install Node and NPM via `n`
RUN curl -sL https://git.io/n-install | N_PREFIX=/n bash -s -- -y
ENV PATH /n/bin:$PATH
RUN n lts
RUN node --version
RUN npm --version
RUN npx --version
