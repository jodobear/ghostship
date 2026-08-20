## Change

<!-- Describe one bounded infrastructure slice. -->

Closes #

## Evidence

- [ ] `scripts/check-secrets.sh`
- [ ] Slice-specific local tests pass on this exact head
- [ ] No production secret, encrypted secret payload, private host inventory,
      generated production hardware config, or recovery material added
- [ ] No VPS, DNS, signer, or production-secret state changed
- [ ] Admin or recovery docs updated when behavior changed

## Review

- [ ] CI green on exact head
- [ ] Codex review requested after exact-head checks passed
- [ ] Review findings fixed in one batch and checks rerun
