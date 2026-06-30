{
  fetchFromGitHub,
  fuse3,
  lib,
  pkg-config,
  rustPlatform,
  udev,
}:
rustPlatform.buildRustPackage rec {
  pname = "vuinputd";
  version = "b9b4d1a";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    udev
    fuse3
  ];

  src = fetchFromGitHub {
    owner = "joleuger";
    repo = "vuinputd";
    rev = version;
    hash = "sha256-eatTqd7A8ZQ7+CeEgGE8J7OAILCXshgq1GUm/Byeeok=";
  };

  cargoHash = "sha256-5+A73HyCgyFy2gHpCbZV+Tlx5rUpUkLGVPxYvDEwVmc=";

  # Recent versions of fuse3 expose additional libfuse_* types that bindgen
  # needs to allowlist alongside the standard fuse_* types.
  postPatch = ''
    substituteInPlace cuse-lowlevel/build.rs \
      --replace-fail '.allowlist_type("(?i)^fuse.*")' '.allowlist_type("(?i)^(fuse|libfuse).*")'
    substituteInPlace vuinputd/systemd/vuinputd.service \
      --replace-fail /usr/local/bin/vuinputd $out/bin/vuinputd
  '';

  postInstall = ''
    install -Dm644 {vuinputd/systemd,$out/lib/systemd/system}/vuinputd.service
    install -Dm444 {vuinputd/udev,$out/lib/udev/rules.d}/90-vuinputd-protect.rules
    install -Dm644 {vuinputd/udev,$out/lib/udev/hwdb.d}/90-vuinputd.hwdb
  '';

  meta = with lib; {
    description = "container-safe mediation daemon for /dev/uinput";
    homepage = "https://github.com/joleuger/vuinputd";
    license = licenses.mit;
    platforms = ["x86_64-linux"];
  };
}
