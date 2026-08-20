#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

if [[ -e .env ]]; then
  if ! git check-ignore --quiet -- .env; then
    echo ".env exists but is not ignored" >&2
    exit 1
  fi

  env_mode="$(stat -c '%a' .env)"
  if [[ "$env_mode" != "600" ]]; then
    echo ".env must have mode 0600; found $env_mode" >&2
    exit 1
  fi
fi

scripts/check-tracked-policy.sh

if command -v gitleaks >/dev/null 2>&1; then
  scanner=(gitleaks)
elif command -v nix >/dev/null 2>&1; then
  scanner=(nix run nixpkgs#gitleaks --)
else
  echo "gitleaks or Nix is required" >&2
  exit 1
fi

"${scanner[@]}" git . --config .gitleaks.toml --redact --no-banner

scan_root="$(mktemp -d "${TMPDIR:-/tmp}/ghostship-secret-scan.XXXXXXXX")"
trap 'rm -rf -- "$scan_root"' EXIT
mkdir -p "$scan_root/index" "$scan_root/untracked"

git checkout-index --all --prefix="$scan_root/index/"

while IFS= read -r -d '' path; do
  [[ -f "$path" && ! -L "$path" ]] || continue
  mkdir -p "$scan_root/untracked/$(dirname "$path")"
  cp -- "$path" "$scan_root/untracked/$path"
done < <(git ls-files -z --others --exclude-standard)

"${scanner[@]}" dir "$scan_root" \
  --config "$repo_root/.gitleaks.toml" \
  --redact \
  --no-banner
