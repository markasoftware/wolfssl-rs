{ pkgs ? (import <nixpkgs> {}), unstablePkgs ? (import <nixos-unstable> {}) }:

pkgs.stdenv.mkDerivation {
  name = "wolfssl-rs";

  nativeBuildInputs = [
    unstablePkgs.cargo

    pkgs.autoreconfHook
    pkgs.libtool
  ];

  LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ];

  # Add glibc, clang, glib, and other headers to bindgen search path
  BINDGEN_EXTRA_CLANG_ARGS =
    # Includes normal include path
    (builtins.map (a: ''-I"${a}/include"'') [
      # add dev libraries here (e.g. pkgs.libvmi.dev)
      pkgs.glibc.dev
    ])
    # Includes with special directory paths
    ++ [
      ''-I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.lib.versions.major pkgs.llvmPackages_latest.libclang.version}/include"''
    ];
}
