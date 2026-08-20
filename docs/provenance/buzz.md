# Buzz source and packaging provenance

Ghostship packages the production relay binaries from official
[`block/buzz`](https://github.com/block/buzz), not from a downstream runtime
fork.

| Role | Repository | Revision |
| --- | --- | --- |
| Runtime source | `block/buzz` | `e5d1dfef7bf24ad527c9c8c1785b613abad574f7` |
| Nix packaging ancestry | `DanConwayDev/buzz`, branch `feat/nix-desktop-relay-support` | `b12739b23da92b0f1e99626b02749ab55c51b8ce` |

Official Buzz no longer contains the downstream Nix files. Ghostship therefore
maintains the minimum relay derivation separately while keeping the runtime
source pin identical to official Buzz. The package installs `buzz-relay`,
`buzz-admin`, and `buzz-pair-relay` only. A later bounded change can be proposed
upstream to DanConwayDev after the package and service module pass local VM and
integration tests.

FIPS compatibility is not claimed by this package build. FIPS is the private
transport boundary around the service; it needs separate WSS, authentication,
MTU, reconnect, Git transfer, and restart-recovery tests.
