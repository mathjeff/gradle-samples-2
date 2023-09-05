#!/bin/bash
set -e

separator="****************************************************************************************************************************************************************"

function echoAndDo() {
  echo "$*"
  eval "$*"
}

function runTest() {
  dryrunArg="$1"
  echo "$separator"
  echo resetting metadata
  echoAndDo git checkout HEAD -- gradle
  echo "$separator"
  echo regenerating metadata
  echoAndDo ./gradlew help --write-verification-metadata pgp,sha256 --export-keys $dryrunArg
  echo "$separator"
  echoAndDo mv gradle/verification-metadata.dryrun.xml gradle/verification-metadata.xml 2>/dev/null || true
  echoAndDo mv gradle/verification-keyring-dryrun.keys gradle/verification-keyring.keys 2>/dev/null || true
  echo "$separator"
  echo running test build
  echoAndDo ./gradlew help
}

if runTest --dry-run; then
  echo "$separator"
  echo "Failed to reproduce the problem. Nice!"
  exit 0
else
  echo "$separator"
  echo "Notice that after regenerating verification metadata with '--dry-run', the subsequent verification fails"
fi

if runTest; then
  echo "$separator"
  echo "Notice that after regenerating verification metadata without '--dry-run', the subsequent verification succeeds"
  echo "However, the task we're running in this test (:help) shouldn't have to resolve any configurations, so it seems that this should also still work with --dry-run"
else
  echo "$separator"
  echo "That's interesting, removing '--dry-run' didn't fix the problem: --write-verification-metadata still didn't cause the next build to succeed"
fi

exit 1
