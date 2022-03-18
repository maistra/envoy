workspace(name = "envoy")

load("//bazel:api_binding.bzl", "envoy_api_binding")

envoy_api_binding()

load("//bazel:api_repositories.bzl", "envoy_api_dependencies")

envoy_api_dependencies()

load("//bazel:repositories.bzl", "envoy_dependencies", "BUILD_ALL_CONTENT")

envoy_dependencies()

load("//bazel:repositories_extra.bzl", "envoy_dependencies_extra")

envoy_dependencies_extra()

load("@base_pip3//:requirements.bzl", "install_deps")

install_deps()

load("//bazel:dependency_imports.bzl", "envoy_dependency_imports")

envoy_dependency_imports()

new_local_repository(
    name = "openssl",
    build_file = "openssl.BUILD",
    path = "/usr/lib64/",
)
new_local_repository(
    name = "emscripten_toolchain",
    path = "/opt/emsdk/",
    build_file_content = BUILD_ALL_CONTENT,
)
