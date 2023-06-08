# Anvil

A Docker Development Build and Test Container where Projects are hammered into shape.

> Anvil: a heavy iron block with a flat top and concave sides, on which metal can be hammered and shaped.

![Docker Pulls](https://img.shields.io/docker/pulls/axrs/anvil?style=for-the-badge)

Base Image [Debian:stable-slim](https://hub.docker.com/_/debian). See [Debian Releases](https://www.debian.org/releases/)

***

## Tags

A list of all Docker Image Tags can be found
at [Docker Hub](https://hub.docker.com/repository/docker/axrs/anvil/tags?page=1\&ordering=-name)

> There are a variety of different containers and combinations that can be used. The tools and frameworks included in
> each are outlined below.

The following tools are contained within each build:

### Dart

* Bash
* Dart SDK
* Git
* Powershell

### Java

Everything from the `dart-*` image plus:

* Java + Maven
* Clojure + Leiningen

### DotNet

Everything from the `dart-*` image plus:

* Azure Credential Provider
* .Net SDK
* Azure Functions Core Tools 4

### Flutter

Everything from the `dart-*` image plus:

* Flutter

### <tag>-Cloud

Everything from image <tag> plus:

* AWS CLI @ 1.x
* Azure CLI

## Analyzing

Anvil has been split into several Images that can be combined in an attempt to reduce the overall size, and to narrow
down the scope and purpose. As you can see, the Cloud infrastructure containers (the ones with the AWS and Azure CLI
tools) are substantially larger than the others. The Docker tool [Dive](https://github.com/wagoodman/dive) can be used
to investigate the reason for this increase.

## FAQ

### Why is everything based of the Dart image?

Each of my projects contain various automation scripts and utilities. Historically, these were written with Bash,
however a need surfaced for enhanced cross-platform development support. Dart was selected as a high-level wrapper for
its ease of use, performance, and native bridges.

### Why are the Cloud Images so large?

The Cloud images contain both the AWS and Azure CLIs. Each of which is built using Python. The Azure CLI however
includes the Azure Python SDK and many unnecessary (even unused?) API versions of the `azure-mgmt-network` SDK.
[Azure SDK Trim](https://github.com/clumio-code/azure-sdk-trim) could be used to remove some of this bloat, however it
comes with a risk that something may not work as intended.

[Azure-CLI Weight Issue](https://github.com/Azure/azure-cli/issues/7387)

> **Spoiler**: Almost 900mb (uncompressed) is the Azure CLI
