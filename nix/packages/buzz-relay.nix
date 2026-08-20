{
  lib,
  rustPlatform,
  cmake,
  openssl,
  pkg-config,
  src,
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

  doCheck = false;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

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
