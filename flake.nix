{
  description = "Rust flake with nightly and cargo-binstall";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, flake-utils, rust-overlay, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = (import nixpkgs) {
          inherit system overlays;
        };

        cargoLock = builtins.fromTOML (builtins.readFile ./Cargo.lock);
        wasmBindgen = pkgs.lib.findFirst
          (pkg: pkg.name == "wasm-bindgen")
          (throw "Could not find wasm-bindgen package")
          cargoLock.package;

        wasm-bindgen-cli = pkgs.wasm-bindgen-cli.override {
          version = wasmBindgen.version;
          hash = "sha256-DDUdJtjCrGxZV84QcytdxrmS5qvXD8Gcdq4OApj5ktI=";
          cargoHash = "sha256-Zfc2aqG7Qi44dY2Jz1MCdpcL3lk8C/3dt7QiE0QlNhc=";
        };
      in

      with pkgs;
      {
        devShells.default = mkShell rec {
          nativeBuildInputs = [
            (rust-bin.stable.latest.default.override {
              extensions = [ "rust-analyzer" "clippy" "rust-src" "cargo"];
              targets = ["wasm32-unknown-unknown" "x86_64-unknown-linux-gnu"];
            })
            pkgs.pkg-config
          ];

          buildInputs = [
            tailwindcss
            dioxus-cli
            wasm-bindgen-cli

            #linux desktop
            at-spi2-atk
            atkmm
            cairo
            gdk-pixbuf
            glib
            gtk3
            harfbuzz
            librsvg
            libsoup_3
            pango
            webkitgtk_4_1
            openssl
          ];

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
        };
      }
    );
}
