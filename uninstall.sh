#!/usr/bin/env bash
set -euo pipefail

APP_NAME="codex-army"
PREFIX="${PREFIX:-/usr/local}"
BINDIR="${BINDIR:-$PREFIX/bin}"
INSTALL_PATH="$BINDIR/$APP_NAME"

run_root() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    printf 'error: sudo is required when not running as root\n' >&2
    exit 1
  fi
}

if [[ -e "$INSTALL_PATH" ]]; then
  run_root rm -f "$INSTALL_PATH"
  printf 'removed %s\n' "$INSTALL_PATH"
else
  printf '%s is not installed at %s\n' "$APP_NAME" "$INSTALL_PATH"
fi

