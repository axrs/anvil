#!/usr/bin/env bash
set -euo pipefail
# Holds a list of tags that were built for pushing at the end of the job
built_tags=()

# Various SDK versions. Note Java 15/17 are defined below
dart_version="2.18.3-1"
dart_tag_suffix="dart_2.18"
dotnet_version="6.0.402"
dotnet_tag_suffix="dotnet_6.0"
flutter_version="3.3.5"
flutter_tag_suffix="flutter_3.3"

echo 'BASE'
base_tag="base-$dart_tag_suffix"
full_base_tag="axrs/anvil:$base_tag"
docker build --pull --file Base.Dockerfile --build-arg DART_VERSION="$dart_version" --tag "$full_base_tag" .docker_context/
docker build --file Base_Cloud.Dockerfile --tag "$full_base_tag-cloud" --build-arg ANVIL_BASE_TAG="$base_tag" .docker_context/
built_tags+=("$full_base_tag" "$full_base_tag-cloud")

echo 'DOTNET'
dotnet_base_tag="$base_tag-$dotnet_tag_suffix" #base-dart_2.x-dotnet_6.x
full_dotnet_tag="$full_base_tag-$dotnet_tag_suffix"
docker build --file Base_DotNet.Dockerfile --build-arg ANVIL_BASE_TAG="$base_tag" --build-arg DOTNET_VERSION="$dotnet_version" --tag "$full_dotnet_tag" .docker_context/
docker build --file Base_Cloud.Dockerfile --tag "$full_dotnet_tag-cloud" --build-arg ANVIL_BASE_TAG="$dotnet_base_tag" .docker_context/
built_tags+=("$full_dotnet_tag" "$full_dotnet_tag-cloud")

java_base_tag="$base_tag-java_"
full_java_tag="$full_base_tag-java_"
for version in 15 17; do
	echo "JAVA $version"
	jt="${full_java_tag}$version"
	docker build --file Base_Java.Dockerfile --build-arg ANVIL_BASE_TAG="$base_tag" --build-arg JAVA_VERSION="$version" --tag "$jt" .docker_context/
	docker build --file Base_Cloud.Dockerfile --tag "$jt-cloud" --build-arg ANVIL_BASE_TAG="${java_base_tag}$version" .docker_context/
	built_tags+=("$jt" "$jt-cloud")

	dt="$full_dotnet_tag-java_$version"
	docker build --file Base_Java.Dockerfile --build-arg JAVA_VERSION="$version" --tag "$dt" --build-arg ANVIL_BASE_TAG="$dotnet_base_tag" .docker_context/
	docker build --file Base_Java.Dockerfile --build-arg JAVA_VERSION="$version" --tag "$dt-cloud" --build-arg ANVIL_BASE_TAG="$dotnet_base_tag-cloud" .docker_context/
	built_tags+=("$dt" "$dt-cloud")
done

echo 'FLUTTER'
flutter_base_tag="$base_tag-$flutter_tag_suffix"
full_flutter_tag="$full_base_tag-$flutter_tag_suffix"
docker build --file Base_Flutter.Dockerfile --build-arg ANVIL_BASE_TAG="$base_tag" --build-arg FLUTTER_VERSION="$flutter_version" --tag "$full_flutter_tag" .docker_context/
docker build --file Base_Cloud.Dockerfile --tag "$full_flutter_tag-cloud" --build-arg ANVIL_BASE_TAG="$flutter_base_tag" .docker_context/
built_tags+=("$full_flutter_tag" "$full_flutter_tag-cloud")

for tag in "${built_tags[@]}"; do
	echo "Pushing $tag"
	docker push "$tag"
done
