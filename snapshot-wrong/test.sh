set -e

cd "$(dirname $0)"
separator="****************************************************************************************************************************************************************"

function usage() {
  echo "Usage: $0 <path to gradle source dir>"
  echo "This script:"
  echo " 1. Fetches and applies a commit that modifies the given Gradle to exacerbate a particular race condition"
  echo " 2. Rebuilds Gradle"
  echo " 3. Tests whether the race condition still reproduces"
  exit 1
}

function echoAndDo() {
  echo "$*"
  eval "$*"
}

gradleSourceDir="$1"
if [ "$gradleSourceDir" == "" ]; then
  usage
fi
gradleZipDir="${gradleSourceDir}/subprojects/distributions-full/build/distributions"

# remove existing Gradle distribution to avoid accidentally trying to use a different one than we will be building

function buildGradle {
  echo "$separator"
  cd "${gradleSourceDir}"
  echo "Exacerbating race condition"
  # a test commit that makes the race condition happen more often by adding a sleep
  sleepCommit="75374e10a39fca7b78ad4b26254fc5b6cb04702a"
  if ! git log -1 "$sleepCommit" >/dev/null 2>/dev/null; then
    # fetch the missing commit fist
    echoAndDo git fetch https://github.com/mathjeff/gradle "$sleepCommit"
  fi
  echoAndDo "git cherry-pick --empty=drop $sleepCommit"
  echo "$separator"
  echo "Building Gradle"
  echoAndDo rm -f "$gradleZip"
  echoAndDo ./gradlew :distributions-full:binDistributionZip -Dorg.gradle.ignoreBuildJavaVersionCheck=true
  cd -
  gradleZip="$(find "$gradleZipDir" -type f | head -n 1)"
  mkdir -p "distributions"
  cp "$gradleZip" distributions/gradle-bin.zip
}
buildGradle

echo "$separator"
echo Cleaning build dirs
echoAndDo rm -rf build a/build b/build

echo "$separator"

function runBuild() {
  echo "$separator"
  extraArguments="$@"
  #echoAndDo GRADLE_USER_HOME=build/.gradle-user-home ./gradlew --no-daemon task1 --no-watch-fs --max-workers 3 --parallel --stacktrace
  echoAndDo GRADLE_USER_HOME=build/.gradle-user-home ./gradlew checkInputs --max-workers 3 --info "$extraArguments" | tee log
  if ! grep "BUILD SUCCESSFUL" log >/dev/null; then
    echo "Build failed? That's weird"
    exit 1
  fi
}

runBuild
runBuild
runBuild -PprojectBUsesParentDir
echo "$separator"
if grep -A 4 "Task.*a:checkInputs.*is not up-to-date because:" log | grep -B 1 "has been added"; then
  echo "Notice that :a:checkInputs out-of-date due to unexpected additions under src/main/sample-resources/subdir1"
  exit 1
else
  echo "Failed to reproduce the problem! Nice!"
  exit 0
fi
