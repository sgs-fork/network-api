#!/usr/bin/env bash

BUILDER_NAME=default_builder
if ! docker buildx ls | grep -q "${BUILDER_NAME}"; then
    docker buildx create --name "${BUILDER_NAME}" --use
    docker buildx inspect "${BUILDER_NAME}" --bootstrap
else
    docker buildx use "${BUILDER_NAME}"
fi

NEXUS_VERSION=1.0
docker buildx prune -f
docker buildx build --platform linux/arm64 -t sigeshuo/nexus:1.0-aarch64 -f Dockerfile-aarch64 . --no-cache --push --pull --progress=plain
#docker buildx build --platform linux/arm64 -t sigeshuo/nexus:${NEXUS_VERSION}-aarch64 . --no-cache --push --pull

#docker login
#
#docker push sigeshuo/nexus:${NEXUS_VERSION}
#docker push sigeshuo/nexus:latest