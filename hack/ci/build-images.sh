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

echodate "Building Docker image for $MINOR_VERSION ..."
cd "$MINOR_VERSION"

repository=quay.io/kubermatic/kubelet
version=$(cat version)
architectures="amd64 arm64"

echodate "Kubernetes version: $version"

# build all images
for arch in $architectures; do
  fullTag="$repository:$version-$arch"

  echodate "Building $version-$arch ..."
  buildah build-using-dockerfile \
    --file "Dockerfile.$arch" \
    --tag "$fullTag" \
    --arch "$arch" \
    --override-arch "$arch" \
    --build-arg "VERSION=$version" \
    --format=docker \
    .
done

# create multi-arch manifest
manifest="$repository:$version"

echodate "Creating manifest $manifest ..."
buildah manifest create "$manifest"
for arch in $architectures; do
  buildah manifest add "$manifest" "$repository:$version-$arch"
done

# push manifest, except in presubmits
if [ -z "${DRY_RUN:-}" ]; then
  echodate "Logging into Quay"
  retry 5 buildah login --username "$QUAY_IO_USERNAME" --password "$QUAY_IO_PASSWORD" quay.io

  echodate "Pushing manifest and images ..."
  buildah manifest push --all "$manifest" "docker://$repository:$version"
else
  echodate "Not pushing images, as \$DRY_RUN is set."
fi

echodate "Done."
