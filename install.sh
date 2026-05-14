#!/usr/bin/env bash
set -euo pipefail

APP_NAME="codex-army"
PREFIX="${PREFIX:-/usr/local}"
BINDIR="${BINDIR:-$PREFIX/bin}"
INSTALL_PATH="$BINDIR/$APP_NAME"
RUNTIME_PACKAGES=(
  glibc
  libcap2
  libgcc_s1
  libjitterentropy3
  libopenssl3
  libz1
)

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source_bin="$script_dir/bin/$APP_NAME"

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

if [[ ! -x "$source_bin" ]]; then
  printf 'error: bundled binary not found or not executable: %s\n' "$source_bin" >&2
  exit 1
fi

machine="$(uname -m)"
if [[ "$machine" != "x86_64" ]]; then
  printf 'error: this bundle contains an x86_64 binary, but this system is %s\n' "$machine" >&2
  exit 1
fi

if command -v zypper >/dev/null 2>&1; then
  run_root zypper --non-interactive install --no-recommends "${RUNTIME_PACKAGES[@]}"
else
  printf 'warning: zypper not found; skipping dependency installation\n' >&2
fi

run_root install -d -m 0755 "$BINDIR"
run_root install -m 0755 "$source_bin" "$INSTALL_PATH"

if command -v "$INSTALL_PATH" >/dev/null 2>&1; then
  "$INSTALL_PATH" --version
fi

printf 'installed %s to %s\n' "$APP_NAME" "$INSTALL_PATH"

