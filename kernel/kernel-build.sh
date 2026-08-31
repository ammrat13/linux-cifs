#!/bin/bash
set -e -u -o pipefail

fatal() {
    echo "ERROR: $*" 1>&2
    exit 1
}

# See: https://stackoverflow.com/a/1482133
SCRIPT_FILE=$(readlink -f -- "$0")
SCRIPT_DIR=$(dirname -- "${SCRIPT_FILE}")

BRANCH="${1:-}"
CONFIG_NAME="${2:-}"
DEST_DIR="${3:-}"
[[ -z "${BRANCH}" ]] && fatal "Branch not provided"
[[ -z "${CONFIG_NAME}" ]] && fatal "Configuration file not provided"
[[ -z "${DEST_DIR}" ]] && fatal "Destination directory not provided"

CONFIG_FILE="${SCRIPT_DIR}/config/${CONFIG_NAME}"
[[ ! -e "${CONFIG_FILE}" ]] && fatal "Configuration file doesn't exist"
[[ ! -d "${DEST_DIR}" ]] && fatal "Destination directory doesn't exist"

LINUX_DIR="${SCRIPT_DIR}/linux/"

set -x

pushd "${LINUX_DIR}"
git checkout "${BRANCH}"
popd

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
