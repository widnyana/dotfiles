# Feature flags

Optional behavior in this dotfiles repo is gated two ways:

1. **`command -v <tool>` gates** — the default. A block runs only when its tool is on
   `$PATH`. No configuration, nothing to enable. Most of `devs`, `infrastructure`,
   `android`, `rust`, etc. work this way.
2. **`WID_ENABLE_<x>=1` environment flags** — for the few cases a `command -v` check
   cannot express (opt *into* non-default behavior, or opt *out* of something heavy).
   Flags are read from `office/flags` (git-ignored, machine-local) early in `loader.zsh`,
   before the domain fragments.

## Enabling a flag

```sh
echo 'export WID_ENABLE_HEAVY_COMPLETIONS=1' >> ~/.dotfiles/office/flags
exec zsh
```

## Flags

| Flag | Default | Effect |
|------|---------|--------|
| _(none yet — populated in Stage 7)_ | | |

## Deferred / backlog

Not implemented; captured here so they are not lost:

- **`~/.ssh/config.d/*` managed from the repo**, sops + age encrypted, for easy
  cross-machine sync of SSH host definitions.
- **nix / nix-darwin adoption** — evaluated, deferred as too heavy for now.
- **`config/nixpkgs/` repair** — kept in the repo but non-functional: `flake.lock` is
  missing and `flake.nix` may be corrupt. Fix or remove in a dedicated change.
- **macOS package bootstrap parity** — `Brewfile` exists; keep it in sync with what is
  actually installed by hand.
