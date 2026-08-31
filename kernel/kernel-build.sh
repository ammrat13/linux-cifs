#!/bin/bash
set -e -u -o pipefail

fatal() {
    echo "ERROR: $*" 1>&2
    exit 1
}

# See: https://stackoverflow.com/a/1482133
SCRIPT_FILE=$(readlink -f -- "$0")
SCRIPT_DIR=$(dirname -- "${SCRIPT_FILE}")

CONFIG_NAME="${1:-}"
CONFIG_FILE="${SCRIPT_DIR}/config/${CONFIG_NAME}"
[[ -z "${CONFIG_NAME}" ]] && fatal "Configuration file not provided"
[[ ! -e "${CONFIG_FILE}" ]] && fatal "Configuration file doesn't exist"

DEST_DIR="${2:-}"
[[ -z "${DEST_DIR}" ]] && fatal "Destination directory not provided"
[[ ! -d "${DEST_DIR}" ]] && fatal "Destination directory doesn't exist"

LINUX_DIR="${SCRIPT_DIR}/linux/"

set -x

rm -f \
    "${DEST_DIR}"/linux-*.deb \
    "${DEST_DIR}"/linux-*.buildinfo \
    "${DEST_DIR}"/linux-*.changes
cp "${CONFIG_FILE}" "${LINUX_DIR}/.config"

pushd "${LINUX_DIR}"
make LOCALVERSION=-cifs -j$(nproc) bindeb-pkg
popd

mv \
    "${SCRIPT_DIR}"/linux-*.deb \
    "${SCRIPT_DIR}"/linux-*.buildinfo \
    "${SCRIPT_DIR}"/linux-*.changes \
    "${DEST_DIR}"
