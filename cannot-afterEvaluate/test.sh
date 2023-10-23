set -e

cd "$(dirname $0)"


function runCommand() {
  args="$*"
  echo "$args"
  eval "$args"
}

separator="****************************************************************************************************************************************************************"
echo "$separator"

runCommand "./gradlew :appsearch:appsearch-local-storage:tasks 2>&1 | tee log"
echo "$separator"
if ! grep "BUILD FAILED" log > /dev/null; then
  echo "The build doesn't mention having failed. That's weird"
  exit 1
fi

if grep "resolveDependencies" log; then
  echo "The problem is resolved. Yippee!"
  exit 0
fi

echo "Notice that build failed and doesn't mention the problematic task (resolveDependencies)"

exit 1
