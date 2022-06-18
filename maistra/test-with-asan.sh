#!/bin/bash

# This script will execute Envoy's c++ unit and integration tests with
# address sanitizer enabled. It may point out issues related to both
# undefined behaviour as well as memory management issues (leaks).

# An argument can be passed to this script which when specified will replace
# the "//test/..." part we pass to bazel. This allows one to optionally
# specify which tests to run.

# Furthermore, while this defaults to asan, one can set the SANITIZER env var
# to specify other sanitizers, as support in our bazel setup. 
# As of writing this, known valid values are "tsan" and "msan".

# Lastly, when running this in development flows, one might want to set BAZEL_CONFIG=
# Doing so wipes ci-specific settings, which amongst other things unthrottles the build
# to use all the available memoruy and cpu resources.

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/common.sh"

SANITIZER=${SANITIZER:-asan}
BAZEL_TESTS=${1:-//test/...}

FLAGS="${COMMON_FLAGS} \
  --config=clang-${SANITIZER} \
  --build_tests_only \
  --test_env=ENVOY_IP_TEST_VERSIONS=v4only \
  --test_output=all \
  ${BAZEL_TESTS} \
"

echo "Build tests with ${SANITIZER:asan} enabled."
time bazel build $FLAGS
  
echo "Execute tests with ${SANITIZER:asan} enabled."
time bazel test $FLAGS
