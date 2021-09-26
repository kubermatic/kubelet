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

# This script checks for the existence of new releases for Kubernetes.
# If we already have a stable version (e.g. 1.22.2), only new stable
# versions are considered. If we have an unstable version (e.g. 1.23.0-alpha.1),
# all new versions are considered (e.g. alpha.1 => beta.0).
# The script also checks if new base images are available.

set -euo pipefail

cd $(dirname $0)/../..
source hack/lib.sh

repository="kubermatic/kubelet"
githubUser="kubermatic-bot"

get_pulls() {
  curl -sfL "https://api.github.com/repos/$repository/pulls?state=open"
}

get_version() {
  curl -sfL "https://dl.k8s.io/release/$1-$2.txt"
}

get_baseimage_version() {
  local knownTag="$1"
  local variant="$(echo "$knownTag" | cut -d- -f1)"
  local tmpFile="variants.yaml"

  if [ ! -f "$tmpFile" ]; then
    curl -sfLO "https://raw.githubusercontent.com/kubernetes/release/master/images/build/debian-iptables/variants.yaml"
  fi

  yq read "$tmpFile" "variants.$variant.IMAGE_VERSION"
}

get_checksum() {
  curl -sfL "https://dl.k8s.io/$2/kubernetes-node-linux-$1.tar.gz.sha512"
}

# Before doing anything, check if there are pending PRs that need to be
# merged. Otherwise we might accidentally spam the repository.
if [[ $(get_pulls | jq -r '.[].user.login') =~ "$githubUser" ]]; then
  echodate "A pull request from $githubUser is still open, refusing to create another one."
  exit 0
fi

changedVersions=""
changedBaseImages=""
today="$(date +%Y-%m-%d)"

for dir in v1*; do
  # ignore dir if it's past end-of-life already
  if [ -f "$dir/eol" ] && [[ "$(cat $dir/eol)" < "$today" ]]; then
    continue
  fi

  echodate "Checking $dir"
  knownVersion=$(cat $dir/version)
  baseImageTag=$(cat $dir/baseimage)

  # trim away any suffix like "-alpha.1" and the patch version
  majorMinor="$(echo "${knownVersion#v}" | cut -d- -f1 | cut -d. -f1-2)"

  echodate "  Known version....: $knownVersion (based on $baseImageTag)"

  # this can be an empty string if there is no stable version yet
  newVersion=$(get_version stable $majorMinor || true)

  # determine most recent base image version
  newBaseImageTag="$(get_baseimage_version "$baseImageTag")"

  # if we there is no new stable version, check unstable
  if [ -z "$newVersion" ]; then
    newVersion=$(get_version latest $majorMinor)
  fi

  echodate "  Newest version...: $newVersion (based on $newBaseImageTag)"

  if [ "$knownVersion" != "$newVersion" ] || [ "$baseImageTag" != "$newBaseImageTag" ]; then
    echo "$newVersion" > $dir/version
    echo "$newBaseImageTag" > $dir/baseimage

    for dockerfile in $dir/Dockerfile.*; do
      arch="${dockerfile##*.}"
      checksum=$(get_checksum $arch $newVersion)

      sed -i "s/CHECKSUM=.*/CHECKSUM=$checksum/" $dockerfile
      sed -i "s/FROM \(.*\):$baseImageTag/FROM \1:$newBaseImageTag/" $dockerfile
    done

    if [ "$knownVersion" != "$newVersion" ]; then
      if [ -z "$changedVersions" ]; then
        changedVersions="$newVersion"
      else
        changedVersions="$changedVersions, $newVersion"
      fi
    fi

    if [ "$baseImageTag" != "$newBaseImageTag" ]; then
      if [ -z "$changedBaseImages" ]; then
        changedBaseImages="$dir"
      else
        changedBaseImages="$changedBaseImages, $dir"
      fi
    fi
  fi
done

if ! git diff --stat --exit-code >/dev/null; then
  echodate "Changes detected, creating pull request..."

  # update overview in readme
  update_readme

  branchName="update-$(date +%Y%m%d%H%M)"
  token="${GITHUB_TOKEN:-$(cat /etc/github/oauth | tr -d '\n')}"

  title=""
  if [ -n "$changedVersions" ]; then
    title="add $changedVersions"
  fi

  if [ -n "$changedBaseImages" ]; then
    if [ -n "$title" ]; then
      title="$title, "
    fi

    title="${title}update base images for $changedBaseImages"
  fi

  git checkout -B "$branchName"
  git commit --all --message "$title"
  git push origin "$branchName"

  prBody="hack/ci/pr-body.txt"
  sed -i "s/__VERSIONS__/$changedVersions/g" $prBody

  body=$(
    jq -cr \
      --rawfile "body" "$prBody" \
      --arg "branch" "$branchName" \
      --arg "title" "$title" \
      '{
        title: $title,
        body: $body,
        head: $branch,
        base: "master",
        maintainer_can_modify: true
      }' <<<'{}'
  )

  curl \
    --request POST \
    --silent \
    --header "Authorization: token $token" \
    --header "Content-Type: application/json; charset=utf-8" \
    --header "Accept: application/vnd.github.v3+json" \
    --data "$body" \
    "https://api.github.com/repos/$repository/pulls"
fi

echodate "Done."
