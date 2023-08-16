#!/bin/bash
set -e

acceptsKillallJava="$1"
if [ "$acceptsKillallJava" != "-y" ]; then
  echo 'This script runs `killall -9 java`. Run this script with "-y" to acknowledge this and continue.'
  exit 1
fi

function run() {
  echo "$*"
  eval "$@"
}

separator="***************************************************"

cd "$(dirname $0)"
echo "$separator"
function cleanup() {
  echo "Cleaning up"
  run rm build -rf
  run killall -9 java || true
}
cleanup


function generateSources() {
  echo "$separator"
  echo "Generating about 10,000 files in src/main/kotlin/example"
  mkdir -p src/main/kotlin/example
  cd src/main/kotlin/example
  yes | head -n 10000 | grep -n "y" | sed 's/:y//' | xargs -P 16 -n 1 ../../../../mkkt.sh
  echo -e "package example\nclass Sample {}" >> Sample.kt
  cd -
  echo "Done generating source files in src/main/kotlin/example"
  echo "$separator"
}
if [ ! -e "src/main/kotlin/example" ]; then
  generateSources
fi

echo "$separator"
echo Starting first compilation
echo "$separator"
if timeout -s SIGINT 60 bash -c "echo | ./gradlew compileKotlin -Dorg.gradle.jvmargs=-Xmx3g"; then
  echo "Compiled successfully; failed to reproduce problem"
  exit 2
else
  echo "$separator"
  echo Cancelled first compilation
fi

echo "$separator"
echo Starting second compilation
echo "$separator"
./gradlew compileKotlin -Dorg.gradle.jvmargs=-Xmx10g >/dev/null 2>/dev/null &
sleep 5

echo "$separator"

function daemonIsConnecting() {
  gradlePid="$(ps -ef | grep GradleDaemon | grep -v grep | sed 's/  */ /g' | cut -d ' ' -f 2)"
  echo "Getting stacktrace for Gradle daemon (pid $gradlePid)"
  echo "$gradlePid" | xargs -n 1 jstack -l > build/stack
  if grep getDaemon build/stack; then
    # still connecting
    return 0
  else
    return 1
  fi
}
echo "$separator"
echo "Waiting for the Gradle daemon to try connecting to the Kotlin daemon"
for i in {1..20}; do
  if daemonIsConnecting; then
    break
  fi
  echo "Waiting more for the Gradle daemon to try connecting to the Kotlin daemon"
  sleep 1
done
echo "$separator"

if daemonIsConnecting; then
  echo "The Gradle daemon is connecting to the Kotlin compilation daemon"
else
  echo "Failed to reproduce the problem!"
  exit 2
fi
echo "$separator"
echo "Waiting a little bit to demonstrate that the connection process takes a while"
sleep 2
echo "$separator"
if daemonIsConnecting; then
  echo "The Gradle daemon is still connecting to the Kotlin compilation daemon, multiple seconds later. See the stacktrace at build/stack:"
  grep getDaemon build/stack -C 7 --color
  exit 1
else
  echo "Failed to reproduce the problem!"
  exit 0
fi
