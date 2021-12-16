#!/usr/bin/env pwsh
If(!(test-path '.dart_tool') -Or -not(Test-Path -Path 'pubspec.lock' -PathType Leaf))
{
    & dart pub get | Out-Null
}
& dart run chassis_forge:build --directory tool --main tool/main.dart --executable-target kernel --verbose | Out-Null
& dart run tool/main.dill @args
