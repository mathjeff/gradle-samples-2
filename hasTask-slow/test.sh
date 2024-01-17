set -e

cd "$(dirname $0)"


function runCommand() {
  args="$*"
  echo "$args"
  eval "$args"
}

separator="****************************************************************************************************************************************************************"
function runTest() {
  extraArgs=$1

  runCommand "./gradlew :sample --no-daemon -m $extraArgs | tail"
}

echo "$separator"
echo doing warmup build
echo "$separator"
runTest

echo "$separator"
echo doing first comparison build
echo "$separator"
runTest

echo "$separator"
echo doing second comparison build
echo "$separator"
runTest -PdoLookups

echo "Notice the difference in project configuration duration caused by calling taskGraph.hasTask(String)"
