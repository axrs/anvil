#!/usr/bin/env bash
set -euo pipefail

docker images -a | grep "anvil" | awk '{print $3}' | xargs docker rmi --force || true

# Build and tag new containers
readarray -t combinations < <(jq -c '.[]' combinations.json)
IFS=$'\n'
for combination in "${combinations[@]}"; do
	dart_version=$(jq -r '.dartVersion' <<<"${combination}")
	java_version=$(jq -r '.javaVersion // empty' <<<"${combination}")
	clojure_version=$(jq -r '.clojureVersion // empty' <<<"${combination}")
	dotnet_version=$(jq -r '.dotnetVersion // empty' <<<"${combination}")
	flutter_version=$(jq -r '.flutterVersion // empty' <<<"${combination}")
	android_version=$(jq -r '.androidVersion // empty' <<<"${combination}")
	android_build_tools_version=$(jq -r '.androidBuildToolsVersion // empty' <<<"${combination}")
	readarray -t tags < <(jq -cr '.tags[]' <<<"${combination}")
	for tag in "${tags[@]}"; do
		echo "$tag"
		docker build \
			--pull \
			--file Anvil.Dockerfile \
			--platform linux/amd64 \
			--build-arg DART_VERSION="$dart_version" \
			--build-arg INCLUDE_CLOUD="false" \
			--build-arg JAVA_VERSION="$java_version" \
			--build-arg CLOJURE_VERSION="$clojure_version" \
			--build-arg DOTNET_VERSION="$dotnet_version" \
			--build-arg FLUTTER_VERSION="$flutter_version" \
			--build-arg ANDROID_VERSION="$android_version" \
			--build-arg ANDROID_BUILD_TOOLS_VERSION="$android_build_tools_version" \
			--tag "axrs/anvil:$tag" \
			scripts/
		docker build \
			--file Anvil.Dockerfile \
			--platform linux/amd64 \
			--build-arg DART_VERSION="$dart_version" \
			--build-arg INCLUDE_CLOUD="true" \
			--build-arg JAVA_VERSION="$java_version" \
			--build-arg CLOJURE_VERSION="$clojure_version" \
			--build-arg DOTNET_VERSION="$dotnet_version" \
			--build-arg FLUTTER_VERSION="$flutter_version" \
			--build-arg ANDROID_VERSION="$android_version" \
			--build-arg ANDROID_BUILD_TOOLS_VERSION="$android_build_tools_version" \
			--tag "axrs/anvil:$tag-cloud" \
			scripts/
	done
	sleep 10
done
unset IFS

# Push all tags
docker push axrs/anvil --all-tags
