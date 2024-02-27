#!/bin/bash

set -e
set -o pipefail
set -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/common.sh"

export BUILD_SCM_REVISION="Maistra PR #${PULL_NUMBER:-undefined}"
export BUILD_SCM_STATUS="SHA=${PULL_PULL_SHA:-undefined}"

# Build
time bazel build \
  ${COMMON_FLAGS} \
  //source/exe:envoy-static

echo "Build succeeded. Binary generated:"
bazel-bin/source/exe/envoy-static --version

# By default, `bazel test` command performs simultaneous
# build and test activity.
# The following build step helps reduce resources usage
# by compiling tests first.
# Build tests

time bazel build \
  ${COMMON_FLAGS} \
  --build_tests_only \
  -- \
  //test/... \
  -//test/extensions/listener_managers/listener_manager:listener_manager_impl_quic_only_test

function run_tests() {
# Run tests without tests that timeout
time bazel test \
  ${COMMON_FLAGS} \
  --build_tests_only \
  --spawn_strategy=local \
  -- \
  $1
}

# --cache_test_results=no \

# Run the tests in smaller blocks rather than attempt to 
# share resources to run //test/... 
# This is a remedy for the tests that would time out.
run_tests "//test/common/..."
run_tests "//test/config_test/..."
run_tests "//test/dependencies/..."
run_tests "//test/exe/..."

run_tests "//test/extensions/access_loggers/..."
run_tests "//test/extensions/bootstrap/..."
run_tests "//test/extensions/clusters/..."
run_tests "//test/extensions/common/..."
run_tests "//test/extensions/compression/..."
run_tests "//test/extensions/config/..."
run_tests "//test/extensions/config_subscription/..."
run_tests "//test/extensions/filters/common/..."
run_tests "//test/extensions/filters/http/... -//test/extensions/filters/http/kill_request:crash_integration_test"
run_tests "//test/extensions/filters/http/kill_request:crash_integration_test"
run_tests "//test/extensions/filters/listener/... -//test/extensions/filters/listener/original_dst:original_dst_integration_test"
# The following test only fails locally, passes on CI.
#run_tests "//test/extensions/filters/listener/original_dst:original_dst_integration_test"
run_tests "//test/extensions/filters/network/..."
run_tests "//test/extensions/filters/udp/..."
run_tests "//test/extensions/formatter/..."
run_tests "//test/extensions/grpc_credentials/..."
run_tests "//test/extensions/health_checkers/..."
run_tests "//test/extensions/http/..."
run_tests "//test/extensions/internal_redirect/..."
run_tests "//test/extensions/io_socket/..."
run_tests "//test/extensions/key_value/..."
run_tests "//test/extensions/listener_managers/... -//test/extensions/listener_managers/listener_manager:listener_manager_impl_quic_only_test"
run_tests "//test/extensions/load_balancing_policies/..."
run_tests "//test/extensions/matching/..."
run_tests "//test/extensions/network/..."
run_tests "//test/extensions/path/..."
run_tests "//test/extensions/rate_limit_descriptors/..."
run_tests "//test/extensions/request_id/..."
run_tests "//test/extensions/resource_monitors/..."
run_tests "//test/extensions/retry/..."
run_tests "//test/extensions/stats_sinks/..."
run_tests "//test/extensions/tracers/..."
run_tests "//test/extensions/transport_sockets/..."
run_tests "//test/extensions/udp_packet_writer/..."
run_tests "//test/extensions/upstreams/..."
run_tests "//test/extensions/watchdog/..."

run_tests "//test/fuzz/..."
run_tests "//test/integration/..."
run_tests "//test/mocks/..."
run_tests "//test/server/..."
run_tests "//test/test_common/..."
run_tests "//test/tools/..."

