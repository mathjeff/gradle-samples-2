#!/bin/bash
# This script generates sample .kt files for testing
set -e
number="$1"
prevNumber="$(echo $number | sed 's/[0-9]$//')"
echo -e "package example\nclass Sample${number} extends Sample${prevNumber} {}" > "Sample${number}.kt"
