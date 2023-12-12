set -e

cd "$(dirname $0)"

function echoAndDo() {
  echo "$*"
  eval "$*"
}
  
function runGradle() {
  echoAndDo "./gradlew $* > log"
}

function dependsOnExternalModule() {
  grep "sample.viewpager2:viewpager2:1.1.0-beta02$" log >/dev/null 2>/dev/null
}

separator="**********************************************************************************"
echo "$separator"
runGradle :viewpager2:viewpager2:dependencies -PoverrideVersion=1.1.0-beta03
echo "$separator"
echoAndDo "grep --color 'sample.viewpager2:viewpager2:1.1.0-beta02' log"
echo "$separator"
if dependsOnExternalModule; then
  echo "Notice above that when the project version is 1.1.0-beta03, after conflict resolution, the dependencies include the external module"
else
  echo "Failed to reproduce the problem. Yippee!"
  exit 0
fi

echo "$separator"
echo "$separator"
runGradle  :viewpager2:viewpager2:dependencies -PoverrideVersion=1.1.2-beta03
echo "$separator"
echoAndDo "grep --color 'sample.viewpager2:viewpager2:1.1.0-beta02' log"
echo "$separator"
if dependsOnExternalModule; then
  echo "Interestingly enough, changing the project version doesn't seem to make a difference anymore - with project version 1.1.2-beta03, the dependencies still include the external module"
else
  echo "Notice that when the project version is 1.1.2-beta03, after conflict resolution, the dependencies don't include the external module"
  echo "Why does project version 1.1.2-beta03 produce a different resolution result than project version 1.1.0-beta03?"
fi
exit 1
