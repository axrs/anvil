#!/usr/bin/env bash
set -euo pipefail

echo 'BASE'
docker build --pull --file Base.Dockerfile --tag axrs/anvil:base .docker_context/
docker build --pull --file Base_Cloud.Dockerfile --tag axrs/anvil:base-cloud --build-arg ANVIL_BASE_TAG=base .docker_context/

echo 'DOTNET'
docker build --file Base_DotNet.Dockerfile --tag axrs/anvil:base-dotnet .docker_context/
docker build --file Base_Cloud.Dockerfile --tag axrs/anvil:base-dotnet-cloud --build-arg ANVIL_BASE_TAG=base-dotnet .docker_context/

echo 'JAVA'
docker build --file Base_Java.Dockerfile --tag axrs/anvil:base-java .docker_context/
docker build --file Base_Cloud.Dockerfile --tag axrs/anvil:base-java-cloud --build-arg ANVIL_BASE_TAG=base-java .docker_context/

echo 'FLUTTER'
docker build --file Base_Flutter.Dockerfile --tag axrs/anvil:base-flutter .docker_context/
docker build --file Base_Cloud.Dockerfile --tag axrs/anvil:base-flutter-cloud --build-arg ANVIL_BASE_TAG=base-flutter .docker_context/

echo 'DEPLOYING'
docker push axrs/anvil:base
docker push axrs/anvil:base-cloud
docker push axrs/anvil:base-dotnet
docker push axrs/anvil:base-dotnet-cloud
docker push axrs/anvil:base-java
docker push axrs/anvil:base-java-cloud
docker push axrs/anvil:base-flutter
docker push axrs/anvil:base-flutter-cloud
