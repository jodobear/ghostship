# Ghostship

Production NixOS infrastructure for Sovereign Engineering alumni:

- Buzz at `buzz.soveng.com`
- Pyramid relay, GRASP, and GitWorkshop at `ngit.soveng.com`
- Blossom at `blossom.soveng.com`
- nPanel at `npanel.soveng.com` (last priority)
- FIPS transit-core networking

## Status

Local NixOS VM foundation only. Nothing here is ready for production deployment yet.
Production credentials, private host inventory, generated hardware configuration,
and recovery secrets must remain outside Git.

Target primary node: 2 vCPU, 8 GB RAM, 100 GB disk. Recovery objective: RPO 24
hours, RTO 12 hours. Backups target a separate FIPS node.

No VPS changes are permitted until the local multi-VM rehearsal passes and an
operator explicitly approves deployment.

## Local Nix foundation

The first bounded infrastructure slice provides a generic local VM only. It has
no production hardware, SSH keys, peer inventory, secrets, Buzz, Pyramid, or
FIPS service configuration.

```bash
nix flake check --no-build --show-trace
nix build .#checks.x86_64-linux.vm-system --no-link
nix build .#checks.x86_64-linux.vm-boot --no-link
```

The boot check uses 2 vCPU, 8 GiB RAM, and a sparse 100 GiB disk, waits for
`multi-user.target`, and verifies the guest resource ceiling.

## Repository safety

Install Gitleaks, then run `scripts/check-secrets.sh` before every commit. The
check verifies that local `.env` remains ignored and mode 0600 without reading
or printing its contents. Forbidden production path classes are rejected in the
current index and every reachable commit, independent of mutable ignore rules.
`.env.example` is permitted but scanned. Staged Git blobs and nonignored
untracked files are scanned separately, so worktree changes cannot hide a
staged secret. See `CONTRIBUTING.md` for the production-data boundary.
