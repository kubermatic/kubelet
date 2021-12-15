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

### Contains commonly used functions for the other scripts.

retry() {
  # Works only with bash but doesn't fail on other shells
  start_time=$(date +%s)
  set +e
  actual_retry $@
  rc=$?
  set -e
  elapsed_time=$(($(date +%s) - $start_time))
  write_junit "$rc" "$elapsed_time"
  return $rc
}

# We use an extra wrapping to write junit and have a timer
actual_retry() {
  retries=$1 ; shift

  count=0
  delay=1
  until "$@"; do
    rc=$?
    count=$(( count + 1 ))
    if [ $count -lt "$retries" ]; then
      echo "Retry $count/$retries exited $rc, retrying in $delay seconds..." >/dev/stderr
      sleep $delay
    else
      echo "Retry $count/$retries exited $rc, no more retries left." >/dev/stderr
      return $rc
    fi
    delay=$(( delay * 2 ))
  done
  return 0
}

echodate() {
  # do not use -Is to keep this compatible with macOS
  echo "[$(date +%Y-%m-%dT%H:%M:%S%:z)]" "$@"
}

write_junit() {
  # Doesn't make any sense if we don't know a testname
  if [ -z "${TEST_NAME:-}" ]; then return; fi
  # Only run in CI
  if [ -z "${ARTIFACTS:-}" ]; then return; fi

  rc=$1
  duration=${2:-0}
  errors=0
  failure=""
  if [ "$rc" -ne 0 ]; then
    errors=1
    failure='<failure type="Failure">Step failed</failure>'
  fi
  TEST_NAME="[Kubelet] ${TEST_NAME#\[Kubelet\] }"
  cat <<EOF > ${ARTIFACTS}/junit.$(echo $TEST_NAME|sed 's/ /_/g').xml
<?xml version="1.0" ?>
<testsuites>
    <testsuite errors="$errors" failures="$errors" name="$TEST_NAME" tests="1">
        <testcase classname="$TEST_NAME" name="$TEST_NAME" time="$duration">
          $failure
        </testcase>
    </testsuite>
</testsuites>
EOF
}

update_readme() {
  today="$(date +%Y-%m-%d)"
  archs="amd64 arm64"

  overview=''
  overview+=$'| Minor | Latest Version | multi-arch |'

  for arch in $archs; do
    overview+=" $arch |"
  done

  overview+=$'\n'

  overview+=$'| ----- | ------- | ---------- |'
  for arch in $archs; do
    overview+=" ----- |"
  done
  overview+=$'\n'

  for dir in $(find . -name 'v*' -type d | sort -V -r); do
    knownVersion=$(cat $dir/version)
    majorMinor="$(echo "${knownVersion#v}" | cut -d- -f1 | cut -d. -f1-2)"

    eolNote=""
    if [ -f "$dir/eol" ] && [[ "$(cat $dir/eol)" < "$today" ]]; then
      eolNote=" (EOL)"
    fi

    multiarch="quay.io/kubermatic/kubelet:$knownVersion"
    overview+="| ${majorMinor}$eolNote | $knownVersion | [\`$knownVersion\`](https://$multiarch) |"

    for arch in $archs; do
      dockerfile="$dir/Dockerfile.$arch"

      if [ -f "$dockerfile" ]; then
        archImage="quay.io/kubermatic/kubelet:$knownVersion-$arch"
        overview+=" [\`$knownVersion-$arch\`](https://$archImage) |"
      fi
    done

    overview+=$'\n'
  done

  # we don't have perl, we don't have python, but we have hacks!

  # replace newlines with placeholder
  newline="\n"
  placeholder="\f"

  cat README.md | tr "$newline" "$placeholder" > README.md.single
  overview=$(echo "$overview" | tr "$newline" "$placeholder")

  # replace actual content
  sed -E -i "s#(<!-- versions_start -->).*(<!-- versions_end -->)#\1\n$overview\n\2#g" README.md.single

  # turn back to normal newlines
  cat README.md.single | tr "$placeholder" "$newline" > README.md
}
