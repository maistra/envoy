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
export CI_CONFIG=${CI_CONFIG:-1}

COMMON_FLAGS="\
    --config=${ARCH} \
"
if [ "${CI_CONFIG}" -eq "1" ]; then
  COMMON_FLAGS+=" --config=ci-config "  
fi

if [ -n "${BAZEL_REMOTE_CACHE}" ]; then
  COMMON_FLAGS+=" --remote_cache=${BAZEL_REMOTE_CACHE} "
elif [ -n "${BAZEL_DISK_CACHE}" ]; then
  COMMON_FLAGS+=" --disk_cache=${BAZEL_DISK_CACHE} "
fi