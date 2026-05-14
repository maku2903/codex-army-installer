#!/usr/bin/env bash
set -euo pipefail

SOURCE_REPO="${SOURCE_REPO:-https://github.com/sieciowiecxyz/codex-army.git}"
SOURCE_REF="${SOURCE_REF:-main}"
VERSION="${VERSION:-0.0.0}"
TARGET_TRIPLE="${TARGET_TRIPLE:-x86_64-unknown-linux-gnu}"
RPM_VERSION="$(printf '%s' "$VERSION" | sed -E 's/^[vV]//; s/[^A-Za-z0-9_.+]/_/g')"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(realpath "$script_dir/..")"
work_dir="$repo_dir/work/source"
dist_dir="$repo_dir/dist"
bundle_dir="$repo_dir/work/codex-army-installer"

rm -rf "$repo_dir/work" "$dist_dir"
mkdir -p "$repo_dir/work" "$dist_dir"

git clone --depth 1 --branch "$SOURCE_REF" "$SOURCE_REPO" "$work_dir" 2>/dev/null || {
  git clone "$SOURCE_REPO" "$work_dir"
  git -C "$work_dir" checkout "$SOURCE_REF"
}

source_commit="$(git -C "$work_dir" rev-parse HEAD)"

(
  cd "$work_dir/codex-rs"
  cargo build -p codex-cli --bin codex-army --release --locked
)

binary="$work_dir/codex-rs/target/release/codex-army"
if [[ ! -x "$binary" ]]; then
  printf 'error: expected binary was not built: %s\n' "$binary" >&2
  exit 1
fi

mkdir -p "$bundle_dir/bin"
install -m 0755 "$binary" "$bundle_dir/bin/codex-army"
install -m 0755 "$repo_dir/install.sh" "$bundle_dir/install.sh"
install -m 0755 "$repo_dir/uninstall.sh" "$bundle_dir/uninstall.sh"

cat > "$bundle_dir/BUILD-INFO.txt" <<EOF
source_repo=$SOURCE_REPO
source_ref=$SOURCE_REF
source_commit=$source_commit
version=$VERSION
target=$TARGET_TRIPLE
built_on=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

(
  cd "$bundle_dir"
  sha256sum bin/codex-army install.sh uninstall.sh BUILD-INFO.txt > SHA256SUMS
)

safe_ref="$(printf '%s' "$SOURCE_REF" | tr '/:@ ' '----')"
tar_name="codex-army-installer-${safe_ref}-x86_64.tar.gz"
tar -C "$repo_dir/work" -czf "$dist_dir/$tar_name" codex-army-installer

"$script_dir/build-rpm.sh" "$binary" "$RPM_VERSION" "$dist_dir"

(
  cd "$dist_dir"
  sha256sum "$tar_name" codex-army-*.rpm > SHA256SUMS
)

printf 'source commit: %s\n' "$source_commit"
find "$dist_dir" -maxdepth 1 -type f -printf '%p\n' | sort
