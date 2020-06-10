#!/bin/bash

OPENSSL_VERSION=$(rpm -qi openssl-devel | grep Version | awk '{print $3}')
if [ -z "${OPENSSL_VERSION}" ]; then
  OPENSSL_VERSION=$(pkg-config --modversion openssl)

  if [ -z "${OPENSSL_VERSION}" ]; then
    OPENSSL_VERSION="Unknown"
  fi
fi

echo "#define ENVOY_SSL_VERSION \"OpenSSL_${OPENSSL_VERSION}\""