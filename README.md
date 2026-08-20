# Ghostship

Production NixOS infrastructure for Sovereign Engineering alumni:

- Buzz at `buzz.soveng.com`
- Pyramid relay, GRASP, and GitWorkshop at `ngit.soveng.com`
- Blossom at `blossom.soveng.com`
- nPanel at `npanel.soveng.com` (last priority)
- FIPS transit-core networking

## Status

Repository bootstrap only. Nothing here is ready for production deployment yet.
Production credentials, private host inventory, generated hardware configuration,
and recovery secrets must remain outside Git.

Target primary node: 2 vCPU, 8 GB RAM, 100 GB disk. Recovery objective: RPO 24
hours, RTO 12 hours. Backups target a separate FIPS node.

No VPS changes are permitted until the local multi-VM rehearsal passes and an
operator explicitly approves deployment.

## Repository safety

Install Gitleaks, then run `scripts/check-secrets.sh` before every commit. The
check verifies that local `.env` remains ignored and mode 0600 without reading
or printing its contents. Forbidden production path classes are rejected in the
current index and every reachable commit, independent of mutable ignore rules.
`.env.example` is permitted but scanned. Staged Git blobs and nonignored
untracked files are scanned separately, so worktree changes cannot hide a
staged secret. See `CONTRIBUTING.md` for the production-data boundary.
