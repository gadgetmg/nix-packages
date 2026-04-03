{
  autoreconfHook,
  cmake,
  docbook-xsl-nons,
  fetchFromGitHub,
  gst_all_1,
  gtk-doc,
  lib,
  meson,
  ninja,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "gst-interpipe";
  version = "1.1.10";
  src = fetchFromGitHub {
    owner = "RidgeRun";
    repo = "gst-interpipe";
    rev = "v${version}";
    hash = "sha256-C4RZAdfsVsg4a5/tZl9i/fZv2zlKvbOY0eGqaxw1ONI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    autoreconfHook
    gtk-doc
    docbook-xsl-nons
  ];

  buildInputs = [gst_all_1.gstreamer gst_all_1.gst-plugins-base];

  cmakeFlags = [
    (lib.cmakeBool "enable-gtk-doc" false)
  ];
}
