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

# This script can be run manually after a PR by kubermatic-bot has been
# merged. It will set tags for the new Kubernetes versions and push those
# to Github, triggering images being built.
# Manual "confirmation" of new versions is not a bug, but a feature. This
# allows non-automated PRs to freely update images and scripts without
# immediately triggering new images being built.

cd $(dirname $0)/..
source hack/lib.sh

(set -x; git checkout master; git pull)

tagsCreated=""

for dir in v1*; do
  knownVersion=$(cat $dir/version)

  if ! git tag | grep -q -E "^$knownVersion\$"; then
    trimmed="${knownVersion#v}"
    (set -x; git tag -m "version $trimmed" "$knownVersion")
    tagsCreated="$tagsCreated $knownVersion"
  fi
done

if [ -n "$tagsCreated" ]; then
  # push tags individually, because doing it a single push
  # will not trigger the appropriate Prowjobs for new tags
  for tag in $tagsCreated; do
    (set -x; echo git push origin "$tag")
    sleep 3
  done
fi
