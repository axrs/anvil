ARG ANVIL_BASE_TAG="base"
FROM axrs/anvil:$ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PATH="/root/.local/bin:${PATH}"

RUN apt --quiet update \
 && apt --quiet --yes --no-install-recommends install \
    python3 \
    python3-pip \
    python3-venv \
 && rm -rf /var/lib/apt/lists/* \
 && pip3 install --no-cache-dir --upgrade pipx \
 && python3 -m pipx ensurepath \
 && pipx install --system-site-packages --pip-args=--no-cache-dir awscli \
 && pipx install --system-site-packages --pip-args=--no-cache-dir azure-cli \
 && echo '----- Verification' \
 && aws --version \
 && az --version \
 && az \
 && az config set extension.use_dynamic_install=yes_without_prompt \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*