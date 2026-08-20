#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

is_forbidden_path() {
  local path="$1"
  local basename="${path##*/}"
  local basename_lc="${basename,,}"

  case "/$path/" in
    */.private/*|*/.secrets/*|*/secrets/*)
      return 0
      ;;
  esac

  case "$basename_lc" in
    .env.example)
      return 1
      ;;
    .env|.env.*|.gitleaksignore|.sops.yaml|.sops.yml|*.age|*.sops|*.enc|*.enc.*|*.encrypted|*.encrypted.*|*.gpg|*.pgp|*.asc|*.kdbx|*.p12|*.pfx|*.jks|*.jceks|age-pubkey.txt|hardware-configuration.nix|secrets.*|secrets-*|gitleaks-report.*|result|result-*|*.qcow2|*.raw)
      return 0
      ;;
  esac

  return 1
}

check_path() {
  local path="$1"

  if is_forbidden_path "$path"; then
    echo "$path matches a forbidden tracked-path rule" >&2
    exit 1
  fi
}

while IFS= read -r -d '' path; do
  check_path "$path"
done < <(git ls-files -z --cached)

while IFS= read -r commit; do
  while IFS= read -r -d '' path; do
    check_path "$path"
  done < <(git ls-tree -r -z --name-only "$commit")
done < <(git rev-list HEAD)
