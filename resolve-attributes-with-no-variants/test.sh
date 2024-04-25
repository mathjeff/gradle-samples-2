set -e

cd "$(dirname $0)"


function runCommand() {
  args="$*"
  echo "$args"
  eval "$args"
}

separator="****************************************************************************************************************************************************************"
echo "$separator"
if runCommand "./gradlew copyDependencies -PcorrectDependency"; then
  echo "$separator"
  echo "Notice that attributes are set up correctly"
else
  echo "$separator"
  echo "Build failed? That's weird"
  exit 1
fi

echo "$separator"
runCommand "./gradlew copyDependencies 2>&1 | tee log"
echo "$separator"
if grep "None of the variants have attributes" log >/dev/null; then
  echo "Notice that the error message says that none of the variants have attributes."
  echo "A clearer description would be to say that there are no variants"
  exit 1
else
  echo "Failed to reproduce the problem!"
  exit 0
fi
