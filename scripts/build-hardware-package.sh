#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-1.0.0}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PLATFORM_SRC="${REPO_ROOT}/hardware/geeko_line_follower/avr"
DIST_DIR="${REPO_ROOT}/dist"
ARCHIVE_NAME="geeko_line_follower-avr-${VERSION}.zip"
ARCHIVE_PATH="${DIST_DIR}/${ARCHIVE_NAME}"
STAGING_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "${STAGING_DIR}"
}
trap cleanup EXIT

if [[ ! -f "${PLATFORM_SRC}/platform.txt" ]]; then
  echo "error: expected platform at ${PLATFORM_SRC}" >&2
  exit 1
fi

mkdir -p "${DIST_DIR}"
rm -f "${ARCHIVE_PATH}"

rsync -a \
  --exclude='.DS_Store' \
  --exclude='__MACOSX' \
  --exclude='*.swp' \
  --exclude='*~' \
  "${PLATFORM_SRC}/" "${STAGING_DIR}/"

(
  cd "${STAGING_DIR}"
  zip -r "${ARCHIVE_PATH}" . \
    -x "*.DS_Store" \
    -x "*__MACOSX*" \
    -x "*.swp" \
    -x "*~"
)

SIZE="$(wc -c < "${ARCHIVE_PATH}" | tr -d ' ')"
CHECKSUM="$(shasum -a 256 "${ARCHIVE_PATH}" | awk '{print "SHA-256:" $1}')"
RELEASE_URL="https://github.com/ardugeekph/geeko-raptor-boards/releases/download/v${VERSION}/${ARCHIVE_NAME}"

cat <<EOF

Built: ${ARCHIVE_PATH}

Boards Manager expects platform files at the zip root:
  boards.txt, platform.txt, bootloaders/, variants/

Size (bytes): ${SIZE}
Checksum:     ${CHECKSUM}

GitHub release upload:
  gh release upload "v${VERSION}" "${ARCHIVE_PATH}" --clobber

Package index fields:
  "version": "${VERSION}",
  "url": "${RELEASE_URL}",
  "archiveFileName": "${ARCHIVE_NAME}",
  "checksum": "${CHECKSUM}",
  "size": "${SIZE}"

EOF
