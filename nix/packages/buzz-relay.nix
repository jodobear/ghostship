{
  lib,
  rustPlatform,
  cacert,
  cmake,
  git,
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
  cargoTestFlags = [
    "-p"
    "buzz-relay"
    "-p"
    "buzz-admin"
    "-p"
    "buzz-pair-relay"
  ];
  checkFlags = [
    # These eight tests require a migrated live PostgreSQL database. They are
    # covered by the later service-integration VM, not this package build.
    "--skip"
    "api::admin::tests::feedback_attachment_rejects_unknown_feedback"
    "--skip"
    "api::admin::tests::report_detail_rejects_unknown_report"
    "--skip"
    "api::media::tests::media_read_accepts_range_header_only_after_auth"
    "--skip"
    "api::media::tests::media_read_rejects_upload_verb_wrong_server_and_wrong_x"
    "--skip"
    "api::media::tests::media_read_with_valid_server_scoped_token_reaches_sidecar_gate"
    "--skip"
    "api::media::tests::media_reads_reject_unauthenticated_get_and_head_before_sidecar_gate"
    "--skip"
    "api::media::tests::upload_concurrency_limit_is_scoped_by_community"
    "--skip"
    "api::media::tests::upload_rate_limiter_is_scoped_by_community"

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
