# codex-army-installer

Release builder for `codex-army` on openSUSE `x86_64`.

The source repository is:

```text
https://github.com/sieciowiecxyz/codex-army
```

This repository does not vendor the source tree. The release workflow clones the source repository,
builds `codex-army`, then publishes:

- `codex-army-installer-<ref>-x86_64.tar.gz`
- `codex-army-<version>-1.x86_64.rpm`

## Build Locally

```bash
./scripts/build-release.sh
```

Build a specific branch, tag, or commit:

```bash
SOURCE_REF=main ./scripts/build-release.sh
SOURCE_REF=v1.2.3 ./scripts/build-release.sh
SOURCE_REF=<commit-sha> ./scripts/build-release.sh
```

Outputs are written to `dist/`.

## GitHub Releases

Use the `Build and Release` workflow.

- `workflow_dispatch` builds any selected `source_ref`.
- pushing a tag like `v0.1.0` builds and publishes a GitHub Release.

For unattended release creation, the workflow needs the default `GITHUB_TOKEN` permissions:

```yaml
contents: write
```

## Install From Tarball

On the target openSUSE machine:

```bash
tar -xzf codex-army-installer-*.tar.gz
cd codex-army-installer
./install.sh
```

By default the binary is installed to `/usr/local/bin/codex-army`.

To install into `$HOME/.local/bin`:

```bash
PREFIX="$HOME/.local" ./install.sh
```

## Install From RPM

```bash
sudo zypper install ./codex-army-*.x86_64.rpm
```

