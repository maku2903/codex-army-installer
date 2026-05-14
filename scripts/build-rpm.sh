#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 3 ]]; then
  printf 'usage: %s <binary> <version> <out-dir>\n' "$0" >&2
  exit 2
fi

binary="$(realpath "$1")"
version="$2"
out_dir="$(realpath "$3")"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(realpath "$script_dir/..")"
spec_template="$repo_dir/packaging/codex-army.spec"
topdir="$out_dir/rpmbuild"

if [[ ! -x "$binary" ]]; then
  printf 'error: binary not found or not executable: %s\n' "$binary" >&2
  exit 1
fi

if ! command -v rpmbuild >/dev/null 2>&1; then
  printf 'error: rpmbuild not found. Install it with: sudo zypper install rpm-build\n' >&2
  exit 1
fi

mkdir -p "$topdir"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
install -m 0755 "$binary" "$topdir/SOURCES/codex-army"
sed "s/^Version:.*/Version:        $version/" "$spec_template" > "$topdir/SPECS/codex-army.spec"

rpmbuild --define "_topdir $topdir" -bb "$topdir/SPECS/codex-army.spec"

find "$topdir/RPMS" -type f -name 'codex-army-*.rpm' -exec cp {} "$out_dir/" \;
find "$out_dir" -maxdepth 1 -type f -name 'codex-army-*.rpm' -print

