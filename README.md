# Anvil

A Docker Development Build and Test Container where Projects are hammered into shape.

> Anvil: a heavy iron block with a flat top and concave sides, on which metal can be hammered and shaped.

![Docker Pulls](https://img.shields.io/docker/pulls/axrs/anvil?style=for-the-badge)

Base Image [Debian:bullseye-slim](https://hub.docker.com/\_/debian)

***

## Tags

A list of all Docker Image Tags can be found at [Docker Hub](https://hub.docker.com/repository/docker/axrs/anvil/tags?page=1\&ordering=-name)

|                     | base                                                                                 | base-java                                                                                 | base-cloud                                                                                 | base-java-cloud                                                                                 |
| ------------------- | ------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------- |
| Docker Size         | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base) | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-java) | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-cloud) | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/axrs/anvil/base-java-cloud) |
| Git                 | Y                                                                                    | Y                                                                                         | Y                                                                                          | Y                                                                                               |
| Dart                | Y                                                                                    | Y                                                                                         | Y                                                                                          | Y                                                                                               |
| Node.js             | Y                                                                                    | Y                                                                                         | Y                                                                                          | Y                                                                                               |
| Java 15 + Maven     | N                                                                                    | Y                                                                                         | N                                                                                          | Y                                                                                               |
| Clojure + Leiningen | N                                                                                    | Y                                                                                         | N                                                                                          | Y                                                                                               |
| AWS CLI             | N                                                                                    | N                                                                                         | Y                                                                                          | Y                                                                                               |
| Azure CLI           | N                                                                                    | N                                                                                         | Y                                                                                          | Y                                                                                               |

## Analyzing

Anvil has been split into 4 separate Images in an attempt to reduce the overall size, and to narrow down the scope and
purpose. As you can see, the Cloud infrastructure containers (the ones with the AWS and Azure CLI tools) are
substantially larger than the others. The Docker tool [Dive](https://github.com/wagoodman/dive) can be used to
investigate the reason for this increase.

> **Spoiler**: Almost 900mb (uncompressed) are the Azure and AWS CLI tools installed as Python Packages
