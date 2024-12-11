#!/usr/bin/env bash

NEXUS_VERSION=1.0

docker buildx build --load -t sigeshuo/nexus:${NEXUS_VERSION} -t sigeshuo/nexus:latest . --no-cache

#docker login
#
#docker push sigeshuo/nexus:${NEXUS_VERSION}
#docker push sigeshuo/nexus:latest