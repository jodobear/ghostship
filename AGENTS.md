# Repository review rules

- Treat any credential, secret key, private host identifier, disk UUID, public
  operator key, encrypted production secret payload, or recovery material as a
  blocking finding. Such data must stay outside Git.
- Flag host-specific generated hardware configuration and boot-device values.
  Production hardware is supplied privately at deployment time.
- Flag disabled or bypassed conformance, authentication, TLS, backup, restore,
  FIPS-routing, and secret-scanning gates.
- No VPS, DNS, signer, or production-secret action is authorized by repository
  changes. Those require a separate explicit operator approval.
