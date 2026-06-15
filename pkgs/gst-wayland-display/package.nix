{
  cargo-c,
  fetchFromGitHub,
  glib,
  gst_all_1,
  hwdata,
  lib,
  libgbm,
  libglvnd,
  libinput,
  libxkbcommon,
  linuxHeaders,
  llvmPackages_latest,
  mesa,
  pipewire,
  pkg-config,
  rust,
  rustPlatform,
  stdenv,
  udev,
  wayland,
}:
rustPlatform.buildRustPackage rec {
  pname = "gst-wayland-display";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "games-on-whales";
    repo = "gst-wayland-display";
    rev = "b15285a";
    hash = "sha256-8z5jBjEwDwLtdJBdoGtiBSAX03N9AHD95ozwQXxggxE=";
  };

  nativeBuildInputs = [pkg-config cargo-c rustPlatform.bindgenHook];

  buildInputs = [
    mesa
    libglvnd
    pipewire
    glib
    wayland
    libgbm
    libinput
    libxkbcommon
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    udev
  ];

  doCheck = false;

  cargoLockFile =
    builtins.toFile "cargo.lock" (builtins.readFile "${src}/Cargo.lock");
  cargoLock = {
    lockFile = cargoLockFile;
    outputHashes = {
      "smithay-0.7.0" = "sha256-oOKdNr6+Vm5vNqltgw8DnnyYBhg3Je6fUK2Mt0bc9LI=";
    };
  };

  LIBCLANG_PATH = lib.makeLibraryPath [llvmPackages_latest.libclang.lib];
  BINDGEN_EXTRA_CLANG_ARGS = "-I${linuxHeaders}/include";

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client, which is always dlopen()ed except by the
  # obscure winit backend.
  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-Wl,--pop-state"
  ];

  postPatch = ''
    cp ${cargoLockFile} Cargo.lock
    substituteInPlace wayland-display-core/src/utils/device/gpu.rs \
      --replace "/usr/share/hwdata" "${hwdata}/share/hwdata"
  '';

  buildPhase = ''
    export HOME=$(mktemp -d)
    runHook preBuild
    ${rust.envVars.setEnv} cargo cbuild --release --frozen --prefix=${
      placeholder "out"
    } --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${
      placeholder "out"
    } --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postInstall
  '';
}
