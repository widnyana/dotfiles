#!/usr/bin/env bash
#
# Regenerate cached zsh completion files for tools whose completions were
# previously generated live on every shell startup (slow). Run this once now
# and again after upgrading any of these tools.
#
# ${DOT_DIR}/completions is already on $FPATH (see loader.zsh), so compinit
# autoloads any "_<name>" file dropped in here - no explicit `source` needed.

set -euo pipefail

DOT_DIR="${DOT_DIR:-${HOME}/.dotfiles}"
COMPLETIONS_DIR="${DOT_DIR}/completions"

mkdir -p "${COMPLETIONS_DIR}"

generate() {
  local name="$1"
  shift
  if type "${name}" > /dev/null 2>&1; then
    if "$@" > "${COMPLETIONS_DIR}/_${name}.tmp" 2>/dev/null; then
      mv "${COMPLETIONS_DIR}/_${name}.tmp" "${COMPLETIONS_DIR}/_${name}"
      echo "[✓] refreshed completions: ${name}"
    else
      rm -f "${COMPLETIONS_DIR}/_${name}.tmp"
      echo "[!] skipped (failed): ${name}" >&2
    fi
  else
    echo "[!] skipped (not installed): ${name}" >&2
  fi
}

generate kubectl   kubectl completion zsh
generate minikube  minikube completion zsh
generate trivy     trivy completion zsh
generate helm      helm completion zsh
generate argocd    argocd completion zsh
generate velero    velero completion zsh
generate pinniped  pinniped completion zsh
generate glab      glab completion -s zsh
generate atuin     atuin gen-completions --shell zsh
generate zellij    zellij setup --generate-completion zsh

echo "done. open a new shell to pick up the refreshed completions."
