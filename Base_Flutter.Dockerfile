ARG ANVIL_BASE_TAG="base"
FROM axrs/anvil:$ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
    curl \
    unzip \
 && echo '----- Flutter' \
 && mkdir -p /usr/flutter \
 && echo 'PATH="/usr/flutter/bin:$PATH"' >> /etc/profile \
 && echo 'export PATH' >> /etc/profile \
 && cd /usr/flutter \
 && git clone https://github.com/flutter/flutter.git -b stable . \
 && ./bin/flutter config --no-analytics \
 && ./bin/flutter precache \
 && apt-get -q clean -y && apt-get -q autoclean -y && apt-get -q autoremove -y \
 && rm -rf /var/lib/apt/lists/*

ENV PATH "${PATH}:/usr/flutter/bin"

