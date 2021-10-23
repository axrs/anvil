#!/usr/bin/env bash
set -euo pipefail
if [ ! -d '.dart_tool' ] || [ ! -f 'pubspec.lock' ];then
  dart pub get >/dev/null
fi
dart run chassis_forge:build --directory forge --main forge/main.dart --executable-target kernel --verbose >/dev/null
# shellcheck disable=SC2068
dart run forge/main.dill $@
