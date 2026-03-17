#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PAYLOAD_ROOT="$SCRIPT_DIR"
DEFAULT_PREFIX="${HOME}/.local/ai-agent-toolkit"
PREFIX="$DEFAULT_PREFIX"
FORCE=0

usage() {
  cat <<'EOF'
Usage:
  ./install.sh [--prefix PATH] [--force]

Defaults:
  --prefix  $HOME/.local/ai-agent-toolkit
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prefix)
      PREFIX="${2:-}"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js is required." >&2
  exit 1
fi

NODE_MAJOR="$(node -p 'process.versions.node.split(`.`)[0]')"
if [[ "${NODE_MAJOR}" -lt 20 ]]; then
  echo "Node.js 20 or newer is required for paperclipai." >&2
  exit 1
fi

TARGET_OS="$(uname -s)"
TARGET_ARCH="$(uname -m)"
if [[ "$FORCE" -ne 1 ]]; then
  if [[ "$TARGET_OS" != "Linux" || "$TARGET_ARCH" != "x86_64" ]]; then
    echo "This bundle targets Linux x86_64. Found ${TARGET_OS}/${TARGET_ARCH}." >&2
    exit 1
  fi
fi

BIN_DIR="$PREFIX/bin"
LIB_DIR="$PREFIX/lib"

mkdir -p "$BIN_DIR" "$LIB_DIR"

install -m 0755 "$PAYLOAD_ROOT/bin/gt" "$BIN_DIR/gt"
install -m 0755 "$PAYLOAD_ROOT/bin/bd" "$BIN_DIR/bd"
rm -rf "$LIB_DIR/paperclip-runtime"
cp -R "$PAYLOAD_ROOT/paperclip-runtime" "$LIB_DIR/paperclip-runtime"
ln -sfn ../lib/paperclip-runtime/node_modules/paperclipai/dist/index.js "$BIN_DIR/paperclipai"

cat <<EOF
Installed into: $PREFIX
Add to PATH:
  export PATH="$BIN_DIR:\$PATH"

Verify:
  $BIN_DIR/gt version
  $BIN_DIR/bd version
  $BIN_DIR/paperclipai --version
EOF
