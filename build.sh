#!/usr/bin/env bash
set -euo pipefail

dart_version="2.17.3-1"
dart_tag="dart_2.17"
flutter_version="3.0.2"
flutter_tag="flutter_3.0"

echo 'BASE'
docker build --pull --file Base.Dockerfile --build-arg DART_VERSION="$dart_version" --tag "axrs/anvil:base-$dart_tag" .docker_context/
docker build --file Base_Cloud.Dockerfile --tag "axrs/anvil:base-$dart_tag" --build-arg ANVIL_BASE_TAG="base-$dart_tag" .docker_context/

echo 'FLUTTER'
docker build --file Base_Flutter.Dockerfile --build-arg FLUTTER_VERSION="$flutter_version" --tag "axrs/anvil:base-$dart_tag-$flutter_tag" .docker_context/
docker build --file Base_Cloud.Dockerfile --tag "axrs/anvil:base-$dart_tag-$flutter_tag-cloud" --build-arg ANVIL_BASE_TAG="base-$dart_tag-$flutter_tag" .docker_context/

# TODO DOTNET 5, 6, and 7
#echo 'DOTNET'
#docker build --file Base_DotNet.Dockerfile --tag axrs/anvil:base-dotnet .docker_context/
#docker build --file Base_Cloud.Dockerfile --tag axrs/anvil:base-dotnet-cloud --build-arg ANVIL_BASE_TAG=base-dotnet .docker_context/

# TODO Java 15, and 17 Amazon
#echo 'JAVA'
#docker build --file Base_Java.Dockerfile --tag axrs/anvil:base-java .docker_context/
#docker build --file Base_Cloud.Dockerfile --tag axrs/anvil:base-java-cloud --build-arg ANVIL_BASE_TAG=base-java .docker_context/

# TODO Java 15, and 17 Amazon, DOTNET 5, 6 and 7
#echo 'DOTNET JAVA'
#docker build --file Base_Java.Dockerfile --tag axrs/anvil:base-dotnet-java --build-arg ANVIL_BASE_TAG=base-dotnet .docker_context/
#docker build --file Base_Java.Dockerfile --tag axrs/anvil:base-dotnet-java-cloud --build-arg ANVIL_BASE_TAG=base-dotnet-cloud .docker_context/

echo 'DEPLOYING'
docker push axrs/anvil:base-$dart_tag
docker push axrs/anvil:base-$dart_tag
docker push axrs/anvil:base-$dart_tag-$flutter_tag
docker push axrs/anvil:base-$dart_tag-$flutter_tag-cloud

#docker push axrs/anvil:base-dotnet
#docker push axrs/anvil:base-dotnet-cloud
#docker push axrs/anvil:base-java
#docker push axrs/anvil:base-java-cloud
#docker push axrs/anvil:base-dotnet-java
#docker push axrs/anvil:base-dotnet-java-cloud
