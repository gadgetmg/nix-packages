{
  autoPatchelfHook,
  avahi,
  cmake,
  fetchFromGitHub,
  gst_all_1,
  lib,
  libGL,
  libcxx,
  libevdev,
  libgbm,
  libxkbcommon,
  openssl,
  opus,
  pkg-config,
  rustPlatform,
  shaderc,
  vulkan-loader,
}:
rustPlatform.buildRustPackage rec {
  pname = "moonshine";
  version = "95b6562";

  src = fetchFromGitHub {
    owner = "hgaiser";
    repo = "moonshine";
    rev = version;
    hash = "sha256-AIlibBIWryvPTStHEJYND+DUgT8XEB7gzY8dxKAk8pg=";
  };

  cargoHash = "sha256-BZOUtLYHsQFKk78PAC+RN+8owM72ZjFfumLU9ZUUY1k=";

  # Workaround behavior in fetchCargoVendor to vendor git repos only at the
  # level of their Cargo.toml and not above. This could also be a mistake in
  # the inputtino repository. You may be supposed to put a Cargo.toml at the
  # root of the source.
  postPatch = let
    inputtino-src = fetchFromGitHub {
      owner = "games-on-whales";
      repo = "inputtino";
      rev = "f4ce2b0";
      hash = "sha256-mAAXbIK7aNSLyN7OZX9YeesMvT6OZmT9uAx0md6pyRM=";
    };
  in ''
    substituteInPlace moonshine-core/Cargo.toml \
      --replace-fail 'git = "https://github.com/games-on-whales/inputtino"' 'path = "${inputtino-src}/bindings/rust/inputtino"'
    substituteInPlace dist/moonshine@.service \
      --replace-fail /usr/bin/start-moonshine.sh $out/bin/moonshine
  '';

  RUST_BACKTRACE = "full";
  SHADERC_LIB_DIR = "${shaderc.lib}/lib";
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    rustPlatform.bindgenHook
    autoPatchelfHook
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    openssl
    avahi
    shaderc
    libevdev
    opus
    libxkbcommon
    libgbm
    libcxx
    libGL
  ];

  postInstall = ''
    mkdir -p \
      $out/lib/modules-load.d \
      $out/lib/moonshine/vulkan-layers \
      $out/lib/systemd/system \
      $out/lib/udev.d \
      $out/share/licenses/${pname} \
      $out/share/vulkan/implicit_layer.d

    install -Dm755 LICENSE "$out/share/licenses/${pname}/LICENSE"
    install -Dm644 dist/moonshine@.service "$out/lib/systemd/system/moonshine@.service"
    install -Dm644 dist/60-moonshine.rules "$out/lib/udev/rules.d/60-moonshine.rules"
    install -Dm644 dist/moonshine-modules.conf "$out/lib/modules-load.d/moonshine.conf"
    install -Dm644 dist/VkLayer_moonshine_wsi.json "$out/share/vulkan/implicit_layer.d/VkLayer_moonshine_wsi.json"
  '';

  postFixup = ''
    patchelf \
      --add-needed ${vulkan-loader}/lib/libvulkan.so.1 \
      --add-needed ${libGL}/lib/libEGL.so.1 \
      $out/bin/moonshine
  '';
  meta = with lib; {
    description = "Streaming server for Moonlight clients, written in Rust";
    homepage = "https://github.com/hgaiser/moonshine";
    license = licenses.bsd2;
    platforms = ["x86_64-linux"];
  };
}
