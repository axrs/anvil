#!/usr/bin/env bash
set -euxo pipefail

## Flutter
mkdir -p /usr/flutter
cd /usr/flutter
git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" .
chown -R root:root ./

## Verify
flutter config --no-analytics
flutter config --enable-web
flutter pub global activate webdev
flutter precache
chown -R root:root ./
