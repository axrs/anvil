#!/usr/bin/env bash
set -euxo pipefail

apt-get --quiet update
apt-get --quiet --yes --no-install-recommends install \
	android-sdk \
	unzip
apt-get --quiet --yes clean
apt-get --quiet --yes autoclean
apt-get --quiet --yes autoremove
rm -rf /var/lib/apt/lists/*

## Android SDK Install/Configure
echo 'PATH="/usr/flutter/bin:$ANDROID_SDK_ROOT/cmdline-tools/bin:$PATH"' >>/etc/profile
echo 'export PATH' >>/etc/profile
curl -L https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -o cmdlinetools.zip
unzip cmdlinetools.zip
mv cmdline-tools "$ANDROID_SDK_ROOT/"
rm -rf cmdlinetools.zip cmdline*
sdkmanager --sdk_root=$ANDROID_SDK_ROOT || true
yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses || true
yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT "cmdline-tools;latest" "build-tools;$ANDROID_BUILD_TOOLS_VERSION" "patcher;v4" "platform-tools" "platforms;android-$ANDROID_VERSION" "sources;android-$ANDROID_VERSION" || true

## Verify
flutter precache
flutter doctor --android-licenses
cd /usr/flutter
chown -R root:root ./
