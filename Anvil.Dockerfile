FROM debian:bullseye-slim
LABEL maintainer="Alexander Scott <xander@axrs.io>"
LABEL description="A Docker Development Build and Test Container where my Projects are hammered into shape"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PATH="/root/.local/bin:${PATH}"
COPY base.sh ./
RUN bash ./base.sh

ARG INCLUDE_CLOUD=false
COPY cloud.sh ./
RUN if [ "$INCLUDE_CLOUD" = "true" ];then bash ./cloud.sh; fi

ARG DART_VERSION
COPY dart.sh ./
RUN bash ./dart.sh

ARG JAVA_VERSION=""
COPY java.sh ./
RUN if [ -n "$JAVA_VERSION" ];then bash ./java.sh; fi

ARG CLOJURE_VERSION=""
COPY clojure.sh ./
RUN if [ -n "$CLOJURE_VERSION" ] && [ -n "$JAVA_VERSION" ];then bash ./clojure.sh; fi

ARG DOTNET_VERSION=""
ENV DOTNET_ROOT=/usr/dotnet
ENV PATH="$DOTNET_ROOT:${PATH}"
COPY dotnet.sh ./
RUN if [ -n "$DOTNET_VERSION" ];then bash ./dotnet.sh; fi

ARG FLUTTER_VERSION=""
COPY flutter.sh ./
ENV PATH "/usr/flutter/bin:${PATH}"
RUN if [ -n "$FLUTTER_VERSION" ];then bash ./flutter.sh; fi

ARG ANDROID_VERSION="" ANDROID_BUILD_TOOLS_VERSION=""
ENV ANDROID_SDK_ROOT /usr/lib/android-sdk
ENV PATH "/usr/lib/android-sdk/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/cmdline-tools/bin:${PATH}"
COPY flutter-android.sh ./
RUN if [-n "$FLUTTER_VERSION"] && [ -n "$ANDROID_VERSION" ];then bash ./flutter-android.sh; fi

RUN rm -f *.sh
