set -e

cd "$(dirname $0)"

function runCommand() {
  args="$*"
  echo "$args"
  eval "$args"
}

if runCommand "./gradlew help"; then
  echo "Failed to reproduce the error. Nice!"
  exit 0
else
  echo "Notice that the build failed. Is it supported for a BuildService to request injection of a SoftwareComponentFactory?"
  exit 1
fi
