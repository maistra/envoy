#!/bin/bash

set -e
set -o pipefail
set -x

export CC=clang CXX=clang++

ARCH=$(uname -p)
if [ "${ARCH}" = "ppc64le" ]; then
  ARCH="ppc"
fi
export ARCH

export BUILD_SCM_REVISION="Maistra PR #${PULL_NUMBER:-undefined}"
export BUILD_SCM_STATUS="SHA=${PULL_PULL_SHA:-undefined}"

COMMON_FLAGS="\
    --config=clang \
    --config=${ARCH} \
    --local_ram_resources=28000 \
    --local_cpu_resources=8 \
    --jobs=3 \
    --deleted_packages=test/common/quic,test/common/quic/platform \
    --//bazel:http3=false \
    --color=no \
"

if [ -n "${BAZEL_REMOTE_CACHE}" ]; then
  COMMON_FLAGS+=" --remote_cache=${BAZEL_REMOTE_CACHE} "
elif [ -n "${BAZEL_DISK_CACHE}" ]; then
  COMMON_FLAGS+=" --disk_cache=${BAZEL_DISK_CACHE} "
fi

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
  --disk_cache=/bazel-cache \
  //test/extensions/common/wasm:wasm_vm_test
#//test/extensions/common/wasm:plugin_test                             \
#//test/extensions/common/wasm:wasm_test                               \
#//test/extensions/access_loggers/wasm:config_test                     \
#//test/extensions/bootstrap/wasm:config_test                          \
#//test/extensions/bootstrap/wasm:wasm_test                            \

#  //test/extensions/filters/http/wasm:config_test
#  //test/...
#  //test/common/network:connection_impl_test

