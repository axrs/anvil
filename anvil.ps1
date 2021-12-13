If (!(test-path '.dart_tool') -Or -not(Test-Path -Path 'pubspec.lock' -PathType Leaf)) {
    & dart.exe pub get | Out-Null
}
& dart.exe run chassis_forge:build --directory tool --main tool/main.dart --executable-target kernel --verbose
& dart.exe run tool/main.dill @args
