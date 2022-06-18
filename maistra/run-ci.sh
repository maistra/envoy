#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/common.sh"

# Build
time bazel build \
  ${COMMON_FLAGS} \
  //source/exe:envoy-static

echo "Build succeeded. Binary generated:"
bazel-bin/source/exe/envoy-static --version

# Run tests
time bazel test \
  ${COMMON_FLAGS} \
  --build_tests_only \
  --test_env=ENVOY_IP_TEST_VERSIONS=v4only \
  --test_output=all \
  //test/...

