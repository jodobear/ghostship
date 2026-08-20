{
  lib,
  rustPlatform,
  cacert,
  cmake,
  git,
  openssl,
  pkg-config,
  postgresql,
  postgresqlTestHook,
  src,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "buzz-relay-runtime";
  version = "0.2.1-e5d1dfe";

  inherit src;

  cargoHash = "sha256-wqzRdMkJp1Ed1PSmmlLxO30bLZLrhxNhAoJuwOtFIZY=";
  cargoBuildFlags = [
    "-p"
    "buzz-relay"
    "--bin"
    "buzz-relay"
    "-p"
    "buzz-admin"
    "--bin"
    "buzz-admin"
    "-p"
    "buzz-pair-relay"
    "--bin"
    "buzz-pair-relay"
  ];
  cargoTestFlags = [
    "-p"
    "buzz-relay"
    "-p"
    "buzz-admin"
    "-p"
    "buzz-pair-relay"
  ];
  checkFlags = [
    # This assertion intentionally applies only to debug builds; the packaged
    # and tested server binaries use Cargo's release profile.
    "--skip"
    "nip11::tests::build_nip43_without_self_panics_in_debug"
  ];

  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  nativeCheckInputs = [
    git
    openssl
    postgresql
    postgresqlTestHook
  ];

  postgresqlTestSetupPost = ''
    socket_host="''${PGHOST//\//%2F}"
    export DATABASE_URL="postgresql://$PGUSER@$socket_host/$PGDATABASE"
    ./target/${stdenv.targetPlatform.rust.rustcTarget}/release/buzz-admin migrate
  '';

  buildInputs = [openssl];

  postInstall = ''
    for binary in buzz-relay buzz-admin buzz-pair-relay; do
      test -x "$out/bin/$binary"
    done
  '';

  meta = {
    description = "Buzz relay server and administration binaries";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "buzz-relay";
    platforms = lib.platforms.linux;
  };
}
