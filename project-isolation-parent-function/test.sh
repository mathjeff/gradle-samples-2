set -e

cd "$(dirname $0)"


function runCommand() {
  args="$*"
  echo "$args"
  eval "$args"
}

function cleanup() {
  runCommand rm build .gradle log -rf
}

separator="****************************************************************************************************************************************************************"
echo "$separator"
cleanup
echo "$separator"
runCommand ./gradlew help --configuration-cache --no-daemon -Dorg.gradle.unsafe.isolated-projects=true 2>&1 | tee log
echo "$separator"
if grep "cannot dynamically look up a method in the parent project" log >/dev/null; then
  echo "Notice that the subproject appears to be searching the parent project for the testFunction method, even though this function is defined in the subproject. Why is that?"
  exit 1
else
  echo "Failed to reproduce the error. Nice!"
  exit 0
fi
