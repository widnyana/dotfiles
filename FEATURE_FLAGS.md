# Feature flags

Optional behavior in this dotfiles repo is gated two ways:

1. **`command -v <tool>` gates** — the default. A block runs only when its tool
   is on `$PATH`. No configuration. Most of `devs`, `infrastructure`, `android`,
   `rust`, etc. work this way — if the tool isn't installed, its block is a
   no-op.
2. **`WID_ENABLE_<x>=1` environment flags** — only for what a `command -v` check
   cannot express (opting *into* non-default behavior). Flags are read from
   `office/flags` (git-ignored, machine-local) early in `loader.zsh`, before the
   domain fragments.

## Enabling a flag

```sh
mkdir -p ~/.dotfiles/office
echo 'export WID_ENABLE_CLANG_TOOLCHAIN=1' >> ~/.dotfiles/office/flags
exec zsh
```

## Flags

| Flag | Default | Effect |
|------|---------|--------|
| `WID_ENABLE_CLANG_TOOLCHAIN` | unset (off) | Export `CC=clang` / `CXX=clang++` on Linux too. macOS always uses clang (system toolchain); Fedora defaults to gcc, so this is opt-in. Set in `devs`, cc-toolchain block. |

## Deferred / backlog

Not implemented; captured here so they are not lost:

- **`~/.ssh/config.d/*` managed from the repo**, sops + age encrypted, for easy
  cross-machine sync of SSH host definitions.
- **nix / nix-darwin adoption** — evaluated, deferred as too heavy for now.
- **`config/nixpkgs/` repair** — kept in the repo but non-functional:
  `flake.lock` is missing and `flake.nix` may be corrupt. Fix or remove in a
  dedicated change.
- **`golang` fragment**: `GOCACHE` is missing its `export` (pre-existing). Left
  as-is during the reorg; decide whether that setting should take effect.
