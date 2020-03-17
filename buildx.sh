#!/bin/bash

set -x

IMAGE=mikenye/plex_dupefinder

# Build the image using buildx
docker buildx build -t ${IMAGE}:latest --compress --push --platform linux/amd64,linux/arm/v7,linux/arm64 .
docker pull ${IMAGE}:latest

VERSION=$(docker run --rm --entrypoint cat ${IMAGE}:latest /VERSION | cut -c1-14)

docker buildx build -t ${IMAGE}:${VERSION} --compress --push --platform linux/amd64,linux/arm/v7,linux/arm64 .
