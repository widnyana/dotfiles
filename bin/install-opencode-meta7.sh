#!/usr/bin/env bash
# Install opencode-meta7 and its agent files from the dotfiles repo.
#   curl -fsSL https://raw.githubusercontent.com/widnyana/dotfiles/main/bin/install-opencode-meta7.sh | bash
# Layout (same tree shape as the repo, so the launcher finds ../agents):
#   $OPENCODE_META7_HOME/bin/opencode-meta7
#   $OPENCODE_META7_HOME/agents/*
#   $OPENCODE_META7_BIN/opencode-meta7  ->  symlink to the launcher
# Env:
#   OPENCODE_META7_REPO  git url         (default: https://github.com/widnyana/dotfiles.git)
#   OPENCODE_META7_REF   branch or tag   (default: main)
#   OPENCODE_META7_HOME  install dir     (default: ${XDG_DATA_HOME:-$HOME/.local/share}/opencode-meta7)
#   OPENCODE_META7_BIN   symlink dir     (default: $HOME/.local/bin)
# Requires git and curl-fetched bash. Re-running replaces the install. ~/.config/opencode is not touched.
set -euo pipefail

main() {
  local repo=${OPENCODE_META7_REPO:-https://github.com/widnyana/dotfiles.git}
  local ref=${OPENCODE_META7_REF:-main}
  local home_dir=${OPENCODE_META7_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/opencode-meta7}
  local bin_dir=${OPENCODE_META7_BIN:-$HOME/.local/bin}
  local tmp stage

  command -v git >/dev/null 2>&1 || { echo "install-opencode-meta7: git not found" >&2; exit 1; }
  command -v opencode >/dev/null 2>&1 || echo "install-opencode-meta7: warning: opencode not in PATH" >&2

  tmp=$(mktemp -d)
  trap 'rm -rf "'"$tmp"'"' EXIT

  git clone -q --depth 1 --branch "$ref" --filter=blob:none --sparse "$repo" "$tmp/src"
  git -C "$tmp/src" sparse-checkout set --no-cone /agents/ /bin/opencode-meta7

  [ -f "$tmp/src/bin/opencode-meta7" ] || { echo "install-opencode-meta7: bin/opencode-meta7 missing in $repo@$ref" >&2; exit 1; }
  [ -f "$tmp/src/agents/opencode-meta7.jsonc" ] || { echo "install-opencode-meta7: agents/opencode-meta7.jsonc missing in $repo@$ref" >&2; exit 1; }

  stage=$tmp/stage
  mkdir -p "$stage/bin"
  cp -R "$tmp/src/agents" "$stage/agents"
  cp "$tmp/src/bin/opencode-meta7" "$stage/bin/opencode-meta7"
  chmod 755 "$stage/bin/opencode-meta7"

  mkdir -p "$(dirname "$home_dir")" "$bin_dir"
  rm -rf "$home_dir"
  mv "$stage" "$home_dir"
  ln -sfn "$home_dir/bin/opencode-meta7" "$bin_dir/opencode-meta7"

  printf 'installed %s -> %s\n' "$bin_dir/opencode-meta7" "$home_dir/bin/opencode-meta7"
  case :$PATH: in
    *":$bin_dir:"*) ;;
    *) printf '%s\n' "add to PATH: export PATH=\"$bin_dir:\$PATH\"" ;;
  esac
}

main "$@"
