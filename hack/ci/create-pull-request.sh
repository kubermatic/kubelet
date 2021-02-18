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

repository="kubermatic/kubelet"
githubUser="kubermatic-bot"

get_pulls() {
  curl -sfL "https://api.github.com/repos/$repository/pulls?state=open"
}

get_version() {
  curl -sfL "https://dl.k8s.io/release/$1-$2.txt"
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

for dir in v1*; do
  echodate "Checking $dir"
  knownVersion=$(cat $dir/version)

  # trim away any suffix like "-alpha.1" and the patch version
  majorMinor="$(echo "${knownVersion#v}" | cut -d- -f1 | cut -d. -f1-2)"

  echodate "  Known version....: $knownVersion"

  # this can be an empty string if there is no stable version yet
  newVersion=$(get_version stable $majorMinor || true)

  # if we there is no new stable version, check unstable
  if [ -z "$newVersion" ]; then
    newVersion=$(get_version latest $majorMinor)
  fi

  echodate "  Newest version...: $newVersion"

  if [ "$knownVersion" != "$newVersion" ]; then
    echo "$newVersion" > $dir/version

    for dockerfile in $dir/Dockerfile.*; do
      arch="${dockerfile##*.}"
      checksum=$(get_checksum $arch $newVersion)

      sed -i "s/CHECKSUM=.*/CHECKSUM=$checksum/m" $dockerfile
    done

    if [ -z "$changedVersions" ]; then
      changedVersions="$newVersion"
    else
      changedVersions="$changedVersions, $newVersion"
    fi
  fi
done

if ! git diff --stat --exit-code >/dev/null; then
  echodate "Changes detected, creating pull request..."

  branchName="update-$(date +%Y%m%d%H%M)"
  token="${GITHUB_TOKEN:-$(cat /etc/github/oauth | tr --delete '\n')}"

  git checkout -B "$branchName"
  git commit --all --message "add $changedVersions"
  git push origin "$branchName"

  prBody="hack/ci/pr-body.txt"
  sed -i "s/__VERSIONS__/$changedVersions/g" $prBody

  body=$(
    jq -cr \
      --rawfile "body" "$prBody" \
      --arg "branch" "$branchName" \
      --arg "title" "add $changedVersions" \
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
    --header "Authorization: token $token" \
    --header "Content-Type: application/json; charset=utf-8" \
    --header "Accept: application/vnd.github.v3+json" \
    --data "$body" \
    "https://api.github.com/repos/$repository/pulls"
fi
