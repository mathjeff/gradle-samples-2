set -e

cd "$(dirname $0)"


function runCommand() {
  args="$*"
  echo "$args"
  eval "$args"
}

separator="****************************************************************************************************************************************************************"
echo "$separator"
runCommand rm build .gradle log -rf
echo "$separator"
runCommand ./gradlew :help --configuration-cache -Dorg.gradle.unsafe.isolated-projects=true 2>&1 | tee log
problemMarker="Cannot access project ':subproject' from project ':'"
if grep "$problemMarker" log > /dev/null; then
  echo "Notice configuration cache problems with the build"
else
  echo "No configuration cache problems found in the build? That's interesting"
  exit 1
fi
echo "$separator"
runCommand ./gradlew :help --configuration-cache 2>&1 | tee log
echo "$separator"
runCommand ./gradlew :help --configuration-cache -Dorg.gradle.unsafe.isolated-projects=true 2>&1 | tee log
echo "$separator"

if grep "$problemMarker" log >/dev/null; then
  echo "Failed to reproduce the issue. Yippee!"
else
  echo "Notice that our third build was the same as our first build (project isolation enabled) but produced different results: there was no longer a failure to access the subproject."
  echo "Should org.gradle.unsafe.isolated-projects be an input to the configuration cache?"
  if grep "Reusing configuration cache" log >/dev/null; then
    echo "Notice that the configuration cache was reused in the third build"
  fi
fi
