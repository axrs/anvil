#!/usr/bin/env bash
set -euo pipefail
mkdir -p .docker_context

# Holds a list of tags that were built for pushing at the end of the job
built_tags=()

# Various SDK versions. Note Java 15/17 are defined below
dart_version="2.18.6-1"
flutter_version="3.3.10" # Note: Flutter versions are tied to dart versions
clojure_version="1.11.1.1208"
tag_prefix="axrs/anvil"

base_tag="$tag_prefix:dart-$dart_version"

echo "DART $dart_version"
for version_tag in "2" "2.18" "$dart_version"; do
  root_tag="$tag_prefix:dart-$version_tag"
  docker build --pull \
    --file Dart.Dockerfile \
    --build-arg DART_VERSION=$dart_version \
    --tag $root_tag \
    .docker_context/
  docker build \
    --file Cloud.Dockerfile \
    --build-arg ANVIL_BASE_TAG=$root_tag \
    --tag "$root_tag-cloud" \
    .docker_context/
  built_tags+=("$root_tag" "$root_tag-cloud")
done

dotnet_version="6.0.404"
echo "DOTNET $dotnet_version from $base_tag"
for version_tag in "6" "6.0" "$dotnet_version"; do
  root_tag="$tag_prefix:dotnet-$version_tag"
  docker build \
    --file DotNet.Dockerfile \
    --build-arg ANVIL_BASE_TAG=$base_tag \
    --build-arg DOTNET_VERSION=$dotnet_version \
    --tag $root_tag \
    .docker_context/
  docker build \
    --file Cloud.Dockerfile \
    --build-arg ANVIL_BASE_TAG=$root_tag \
    --tag "$root_tag-cloud" \
    .docker_context/
  built_tags+=("$root_tag" "$root_tag-cloud")
done

dotnet_version="7.0.101"
echo "DOTNET $dotnet_version from $base_tag"
for version_tag in "7" "7.0" "$dotnet_version"; do
  root_tag="$tag_prefix:dotnet-$version_tag"
  docker build \
    --file DotNet.Dockerfile \
    --build-arg ANVIL_BASE_TAG=$base_tag \
    --build-arg DOTNET_VERSION=$dotnet_version \
    --tag $root_tag \
    .docker_context/
  docker build \
    --file Cloud.Dockerfile \
    --build-arg ANVIL_BASE_TAG=$root_tag \
    --tag "$root_tag-cloud" \
    .docker_context/
  built_tags+=("$root_tag" "$root_tag-cloud")
done

for version_tag in "15" "17"; do
  echo "JAVA $version_tag from $base_tag"
  root_tag="$tag_prefix:java-$version_tag"
	docker build \
	  --file Java.Dockerfile \
	  --build-arg ANVIL_BASE_TAG=$base_tag \
	  --build-arg CLOJURE_VERSION=$clojure_version \
	  --build-arg JAVA_VERSION=$version_tag \
	  --tag $root_tag \
	  .docker_context/
	docker build \
	  --file Cloud.Dockerfile \
	  --build-arg ANVIL_BASE_TAG=$root_tag \
	  --tag "$root_tag-cloud" \
	  .docker_context/
  built_tags+=("$root_tag" "$root_tag-cloud")
done

echo "FLUTTER $flutter_version from $base_tag"
for version_tag in "3" "3.3" "$flutter_version"; do
  root_tag="$tag_prefix:flutter-$version_tag"
  docker build \
    --file Flutter.Dockerfile \
    --build-arg ANVIL_BASE_TAG=$base_tag \
    --build-arg FLUTTER_VERSION=$flutter_version \
    --tag $root_tag \
    .docker_context/
  docker build \
    --file Cloud.Dockerfile \
    --tag "$root_tag-cloud" \
    --build-arg ANVIL_BASE_TAG=$root_tag \
    .docker_context/
  built_tags+=("$root_tag" "$root_tag-cloud")
done

for version_tag in "${built_tags[@]}"; do
	echo "Pushing $version_tag"
	docker push "$version_tag"
done
