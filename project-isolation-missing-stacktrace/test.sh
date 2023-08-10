set -e

cd "$(dirname $0)"


function runCommand() {
  args="$*"
  echo "$args"
  eval "$args"
}

function cleanup() {
  runCommand rm build buildSrc/.gradle buildSrc/build buildSrc/child/build -rf
}

separator="****************************************************************************************************************************************************************"
echo "first double checking that the problem doesn't reproduce without the kotlin plugin"
echo "$separator"
cleanup
echo "$separator"
runCommand ./gradlew :help --configuration-cache -Dorg.gradle.unsafe.isolated-projects=true 2>&1 | tee log
echo "$separator"
report="$(find $PWD -name "*.html")"
stacktraceMarker="at sample"
reproducesWithoutKotlinPlugin=false
if grep "$stacktraceMarker" "$report" >/dev/null; then
  reproduceswithoutKotlinPlugin=false
else
  reproducesWithoutKotlinPlugin=true
fi

echo "now confirming that the problem reproduces with the kotlin plugin"
echo "$separator"
cleanup
echo "$separator"
runCommand ./gradlew :help --configuration-cache -Dorg.gradle.unsafe.isolated-projects=true -PbuildSrcChildApplyKotlinPlugin=true 2>&1 | tee log
echo "$separator"
report="$(find $PWD -name "*.html")"
if grep "$stacktraceMarker" "$report" >/dev/null; then
  echo "Failed to reproduce the problem. Nice!"
  exit 0
else
  echo
  echo "No stacktrace is listed for 'sample.SamplePlugin' in ${report}!"
  echo "To see the report:"
  echo "  1. Open file://$report in a web browser."
  echo "  2. Look for the line that says 'Cannot access project :subproject from project :' and click the '>' on the left."
  echo "  3. Look for the line that says \"plugin class 'sample.SamplePlugin'\""
  echo "  4. Notice that no stacktrace is listed"
  echo
  if [ "$reproducesWithoutKotlinPlugin" == "false" ]; then
    echo "Also note that the stacktrace isn't mising if we don't apply the kotlin plugin to buildSrc/child . That's interesting"
  fi
fi
