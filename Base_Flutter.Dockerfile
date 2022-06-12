ARG ANVIL_BASE_TAG="base"
FROM axrs/anvil:$ANVIL_BASE_TAG
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG FLUTTER_VERSION

ENV ANDROID_SDK_ROOT /usr/lib/android-sdk
ENV PATH "/usr/flutter/bin:/usr/lib/android-sdk/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/cmdline-tools/bin:${PATH}"

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get --quiet update \
 && apt-get --quiet --yes --no-install-recommends install \
    android-sdk \
    unzip \
 && echo 'PATH="/usr/flutter/bin:$ANDROID_SDK_ROOT/cmdline-tools/bin:$PATH"' >> /etc/profile \
 && echo 'export PATH' >> /etc/profile \
 && curl -L https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -o cmdlinetools.zip \
 && unzip cmdlinetools.zip \
 && mv cmdline-tools "$ANDROID_SDK_ROOT/" \
 && rm -rf cmdlinetools.zip cmdline* \
 && sdkmanager --sdk_root=$ANDROID_SDK_ROOT || true \
 && yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses || true \
 && yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT "cmdline-tools;latest" "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29" || true

RUN echo '----- Flutter' \
 && mkdir -p /usr/flutter \
 && cd /usr/flutter \
 && git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" . \
 && ./bin/flutter config --no-analytics \
 && ./bin/flutter config --enable-web \
 && ./bin/flutter pub global activate webdev \
 && ./bin/flutter precache \
 && ./bin/flutter doctor --android-licenses \
 && chown -R root:root ./ \
 && apt-get --quiet --yes clean \
 && apt-get --quiet --yes autoclean \
 && apt-get --quiet --yes autoremove \
 && rm -rf /var/lib/apt/lists/*
