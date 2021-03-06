# Anvil

A Docker Development Build and Test Container where Projects are hammered into shape.

> Anvil: a heavy iron block with a flat top and concave sides, on which metal can be hammered and shaped.

![Docker Pulls](https://img.shields.io/docker/pulls/axrs/anvil?style=for-the-badge)

Base Image [Debian:bullseye-slim](https://hub.docker.com/_/debian)

***

## Tags

A list of all Docker Image Tags can be found at [Docker Hub](https://hub.docker.com/repository/docker/axrs/anvil/tags?page=1\&ordering=-name)

> There are a variety of different containers and combinations that can be used. The tools and frameworks included in
> each are outlined below.

* `base-dart_2.17`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17)
* `base-dart_2.17-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-cloud)
* `base-dart_2.17-dotnet_6.0`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-dotnet_6.0)
* `base-dart_2.17-dotnet_6.0-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-dotnet_6.0-cloud)
* `base-dart_2.17-dotnet_6.0-java_15`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-dotnet_6.0-java_15)
* `base-dart_2.17-dotnet_6.0-java_15-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-dotnet_6.0-java_15-cloud)
* `base-dart_2.17-dotnet_6.0-java_17`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-dotnet_6.0-java_17)
* `base-dart_2.17-dotnet_6.0-java_17-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-dotnet_6.0-java_17-cloud)
* `base-dart_2.17-flutter_3.0`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-flutter_3.0)
* `base-dart_2.17-flutter_3.0-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-flutter_3.0-cloud)
* `base-dart_2.17-java_15`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-java_15)
* `base-dart_2.17-java_15-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-java_15-cloud)
* `base-dart_2.17-java_17`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-java_17)
* `base-dart_2.17-java_17-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dart_2.17-java_17-cloud)

### Legacy

The following containers should be considered legacy as they have no clean way of identifying particular SDK versions.
Sudden changes to these containers could break established projects. Where possible, the tags above should be used.

* `base`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base)
* `base-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-cloud)
* `base-dotnet`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dotnet)
* `base-dotnet-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dotnet-cloud)
* `base-dotnet-java`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dotnet-java)
* `base-dotnet-java-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-dotnet-java-cloud)
* `base-flutter`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-flutter)
* `base-flutter-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-flutter-cloud)
* `base-java`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-java)
* `base-java-cloud`: ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-java-cloud)

The following tools are contained within each build:

### Base

* Git
* Dart
* Node.js
* Powershell
* Bash

### Cloud

* AWS CLI
* Azure CLI

### Java

* Java + Maven
* Clojure + Leiningen

### DotNet

* Azure Credential Provider
* .Net SDK
* Azure Functions Core Tools 4

### Flutter

* Flutter

## Analyzing

Anvil has been split into several Images that can be combined in an attempt to reduce the overall size, and to narrow
down the scope and purpose. As you can see, the Cloud infrastructure containers (the ones with the AWS and Azure CLI
tools) are substantially larger than the others. The Docker tool [Dive](https://github.com/wagoodman/dive) can be used
to investigate the reason for this increase.

> **Spoiler**: Almost 900mb (uncompressed) are the Azure and AWS CLI tools installed as Python Packages
