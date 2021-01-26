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

repository=quay.io/kubermatic/kubelet
version=$(git describe --tags --match='v*' --always)
defaultArch=amd64

publish() {
  local localName="$1"
  local remoteName="$repository:$2"

  echodate "Pushing $remoteName ..."
  docker tag "$localName" "$remoteName"
  docker push "$remoteName"
  docker rmi "$remoteName"
}

echodate "Logging into Quay"
docker ps > /dev/null 2>&1 || start-docker.sh
retry 5 docker login -u "$QUAY_IO_USERNAME" -p "$QUAY_IO_PASSWORD" quay.io
echodate "Successfully logged into Quay"

for arch in amd64 arm64; do
  tmpName="kubelet:$version-$arch"
  echodate "Building Docker image for $arch ..."
  docker build -t "$tmpName" -f "Dockerfile.$arch" .

  if [ $arch == "$defaultArch" ]; then
    publish "$tmpName" "$version"
  fi
  publish "$tmpName" "$version-$arch"

  echodate "Untagging temporary image ..."
  docker rmi "$tmpName"
done

echodate "Done."
