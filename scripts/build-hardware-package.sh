#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-1.0.0}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
HARDWARE_SRC="${REPO_ROOT}/hardware/geeko_line_follower"
DIST_DIR="${REPO_ROOT}/dist"
ARCHIVE_NAME="geeko_line_follower-avr-${VERSION}.zip"
ARCHIVE_PATH="${DIST_DIR}/${ARCHIVE_NAME}"
STAGING_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "${STAGING_DIR}"
}
trap cleanup EXIT

if [[ ! -d "${HARDWARE_SRC}/avr" ]]; then
  echo "error: expected hardware at ${HARDWARE_SRC}/avr" >&2
  exit 1
fi

mkdir -p "${DIST_DIR}"
rm -f "${ARCHIVE_PATH}"

STAGE_HARDWARE="${STAGING_DIR}/hardware/geeko_line_follower"
mkdir -p "${STAGE_HARDWARE}"

rsync -a \
  --exclude='.DS_Store' \
  --exclude='__MACOSX' \
  --exclude='*.swp' \
  --exclude='*~' \
  "${HARDWARE_SRC}/" "${STAGE_HARDWARE}/"

(
  cd "${STAGING_DIR}"
  zip -r "${ARCHIVE_PATH}" hardware \
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

Size (bytes): ${SIZE}
Checksum:     ${CHECKSUM}

GitHub release upload:
  gh release create "v${VERSION}" "${ARCHIVE_PATH}" --title "Geeko AVR Boards v${VERSION}"

Package index fields:
  "version": "${VERSION}",
  "url": "${RELEASE_URL}",
  "archiveFileName": "${ARCHIVE_NAME}",
  "checksum": "${CHECKSUM}",
  "size": "${SIZE}"

EOF
