#!/usr/bin/env bash

# Copyright 2021 The Kubermatic Kubernetes Platform contributors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

cd $(dirname $0)/../..
source hack/lib.sh

if [ -z "${MINOR_VERSION:-}" ]; then
  echodate "\$MINOR_VERSION not set, cannot build Docker images."
  exit 1
fi

# DOCKER_REGISTRY_MIRROR_ADDR is injected via Prow preset;
# start-docker.sh is part of the build image.
echodate "Starting docker ..."
DOCKER_REGISTRY_MIRROR="${DOCKER_REGISTRY_MIRROR_ADDR:-}" DOCKER_MTU=1400 start-docker.sh

# enable the modern buildx plugin
echodate "Enabling dockerx plugin ..."
docker buildx install
docker buildx create --use

echodate "Building Docker image for $MINOR_VERSION ..."
cd "$MINOR_VERSION"

repository=quay.io/kubermatic/kubelet
version=$(cat version)
imageTag="$repository:$version"
architectures="amd64 arm64"

echodate "Kubernetes version: $version"

# build all images
for arch in $architectures; do
  fullTag="$imageTag-$arch"

  echodate "Building $version-$arch ..."
  docker buildx build \
    --load \
    --platform="linux/$arch" \
    --build-arg "VERSION=$version" \
    --file "Dockerfile.$arch" \
    --tag "$fullTag" \
    .
done

# push manifest, except in presubmits
if [ -z "${DRY_RUN:-}" ]; then
  echodate "Logging into Quay ..."
  docker login --username "$QUAY_IO_USERNAME" --password "$QUAY_IO_PASSWORD" quay.io

  # build up a space separated string that we use later unquoted
  tags=""

  for arch in $architectures; do
    fullTag="$imageTag-$arch"
    tags="$tags $fullTag"

    echodate "Pushing $fullTag ..."
    docker push "$fullTag"
  done

  docker manifest create --amend "$imageTag" $tags
  for arch in $architectures; do
    docker manifest annotate --arch "$arch" "$imageTag" "$imageTag-$arch"
  done

  echodate "Pushing $imageTag ..."
  docker manifest push --purge "$imageTag"
else
  echodate "Not pushing images because \$DRY_RUN is set."
fi

echodate "Done."
