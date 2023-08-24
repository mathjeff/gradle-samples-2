#!/bin/bash
set -e

cd "$(dirname $0)"
export GRADLE_USER_HOME=out

function echoAndDo() {
  echo "$*"
  eval "$*"
}

echoAndDo ./gradlew --stacktrace --write-verification-metadata pgp,sha256 --dry-run :help
