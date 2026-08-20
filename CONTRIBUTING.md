# Contributing

Use one small issue and pull request per infrastructure slice. Keep commits
reviewable and test the exact pull-request head.

## Never commit

- `.env` files or credentials
- production secrets, including encrypted secret payloads
- private host inventory, addresses, peer identities, or operator keys
- generated production `hardware-configuration.nix`
- host-specific boot-device or persistent disk identifiers
- backup credentials, recovery mnemonics, passphrases, keys, or signer material

Run `scripts/check-secrets.sh` before committing. Production inputs belong in a
private operator-managed directory outside this repository.

`main` must be protected against direct pushes and must require pull requests
and the Security check. The workflow also reuses the prior `main` scanner policy
for push validation. Security-policy files require a separately authorized
administrator change; ordinary pull requests cannot modify them.

## Deployment boundary

Local VM tests and builds do not authorize production deployment. VPS, DNS,
signer, and production-secret changes require explicit operator approval.
