set -e

cd "$(dirname $0)"


function runCommand() {
  args="$*"
  echo "$args"
  eval "$args"
}

separator="****************************************************************************************************************************************************************"
function runTest() {
  extraArgs="$1"

  echo "$separator"
  runCommand rm -rf build .gradle log
  echo "$separator"
  echo | runCommand ./gradlew --no-daemon :help --scan $extraArgs | tee log
  echo "$separator"

  helpMessage="The Gradle Terms of Service have not been agreed to."
  publishingMessage="Publishing build scan"

  if grep "$publishingMessage" log; then
    echo "Gradle published a scan. Great!"
    return 0
  fi
  if grep "$helpMessage" log; then
    echo "Gradle offered advice about how to publish a scan. Great!"
    return 0
  fi

  echo "Notice that even though --scan was passed to Gradle, it didn't publish a scan and didn't offer advice about how to publish one"
  return 1
}

if ! runTest; then
  echo "Reproduced the error even without publishIfAuthenticated? That's interesting"
  exit 1
fi
if runTest -PpublishIfAuthenticated; then
  echo "Failed to reproduce the error. Nice!"
  exit 0
else
  echo "Notice that if publishIfAuthenticated() is enabled, then the '--scan' flag doesn't enable a scan or a warning"
  exit 1
fi
