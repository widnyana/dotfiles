#!/usr/bin/env bash
# Blocks commits staging files under sensitive paths, even via `git add -f`.
# Keep in sync with .gitignore.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

PATTERNS=(
  '^auth_keys$'
  '^config/git/config\.local$'
  '^office/'
  '^vps$'
  '^vpn/'
  '^bin/docker-compose$'
  '^bin/test-ignored\.sh$'
  '^boxes/'
  '^\.trash/'
)

rc=0
while IFS= read -r f; do
  for p in "${PATTERNS[@]}"; do
    if [[ $f =~ $p ]]; then
      echo "sensitive file staged: $f" >&2
      rc=1
      break
    fi
  done
done < <(git diff --cached --name-only)
exit $rc
