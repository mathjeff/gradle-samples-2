set -e

cd "$(dirname $0)"

separator="****************************************************************************************************************************************************************"
echo "$separator"
echo "This test takes approximately 44s to run"
echo "$separator"
echo "./gradlew slowTask --stacktrace | tee log"
./gradlew slowTask --stacktrace 2>&1 | tee log || true

if grep "Current stacktrace of timed out but not yet stopped task" log; then
  echo "Stacktrace is printed in the log"
else
  echo "No stacktrace printed in the log? That's unexpected"
  exit 1
fi
echo "$separator"

if grep "CountWorker" log; then
  echo "Failed to reproduce the problem. Nice!"
else
  echo "Notice that even though CountWorker is what is taking too long, it isn't mentioned in the log."
  exit 1
fi
