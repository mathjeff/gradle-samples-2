set -e
separator="******************************************************************************************************"
function echoAndDo() {
  echo "$*"
  eval "$*"
}

function runBuild() {
  echo "$separator"
  echoAndDo git clean -fdx
  echo "$separator"
  echoAndDo ./gradlew :compose:ui:ui:transformCommonMainDependenciesMetadata --no-daemon --stacktrace
}

runBuild
