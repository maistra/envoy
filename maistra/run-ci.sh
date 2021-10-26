#!/bin/bash

set -e
set -o pipefail
set -x

source /opt/rh/gcc-toolset-9/enable

ARCH=$(uname -p)
if [ "${ARCH}" = "ppc64le" ]; then
  ARCH="ppc"
fi
export ARCH

export BUILD_SCM_REVISION="Maistra PR #${PULL_NUMBER:-undefined}"
export BUILD_SCM_STATUS="SHA=${PULL_PULL_SHA:-undefined}"

COMMON_FLAGS="\
  --incompatible_linkopts_to_linklibs --color=no \
  --local_ram_resources=12288 \
  --local_cpu_resources=3 \
  --jobs=3 \
  --disk_cache=/bazel-cache \
  --//bazel:http3=False \
  --deleted_packages=test/common/quic,test/common/quic/platform \
"

echo "Building envoy binary..."
time bazel build \
  ${COMMON_FLAGS} \
  //source/exe:envoy-static

echo "Build succeeded. Binary generated:"
bazel-bin/source/exe/envoy-static --version

echo "Building tests..."
time bazel build \
  ${COMMON_FLAGS} \
  //test/...

echo "Running tests..."
time bazel test \
  ${COMMON_FLAGS} \
  --build_tests_only \
  --test_env=ENVOY_IP_TEST_VERSIONS=v4only \
  --test_output=all \
  //test/...
