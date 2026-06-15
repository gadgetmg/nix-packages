{
  boost187,
  cmake,
  cudaPackages,
  curl,
  elfutils,
  fake-udev,
  fetchFromGitHub,
  gst-interpipe,
  gst-wayland-display,
  gst_all_1,
  icu,
  lib,
  libevdev,
  libpulseaudio,
  libsysprof-capture,
  libunwind,
  makeWrapper,
  ninja,
  openssl,
  orc,
  pciutils,
  pcre2,
  pkg-config,
  stdenv,
  udev,
  zstd,
}: let
  boost-json-src = fetchFromGitHub {
    owner = "boostorg";
    repo = "json";
    rev = "boost-1.75.0";
    hash = "sha256-c/spP97jrs6gfEzsiMpdt8DDP6n1qOQbLduY+1/i424=";
  };
  eventbus-src = fetchFromGitHub {
    owner = "games-on-whales";
    repo = "eventbus";
    rev = "abb3a48";
    hash = "sha256-LHBsjvZtxid4KIFQclqs2I155J/9UpDR1NhlSFx4OvU=";
  };
  immer-src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "immer";
    rev = "e02cbd795e9424a8405a8cb01f659ad61c0cbbc7";
    hash = "sha256-buIaXxoJSTbqzsnxpd33BUCQtTGmdd10j1ArQd5rink=";
  };
  inputtino-src = fetchFromGitHub {
    owner = "games-on-whales";
    repo = "inputtino";
    rev = "fd136cf";
    hash = "sha256-snbcjCFyBDqTf/jkxvA3Hvkz7/27fCDT5oWFi2lAQn0=";
  };
  mdns-cpp-src = fetchFromGitHub {
    owner = "games-on-whales";
    repo = "mdns_cpp";
    rev = "master";
    hash = "sha256-mG/Ob5SIqcIyp5r5IpFh8bJOSul1zRzKvrvdfywVwcg=";
  };
  fmtlib-src = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "11.1.4";
    hash = "sha256-sUbxlYi/Aupaox3JjWFqXIjcaQa0LFjclQAOleT+FRA=";
  };
  range-src = fetchFromGitHub {
    owner = "ericniebler";
    repo = "range-v3";
    rev = "0.12.0";
    hash = "sha256-bRSX91+ROqG1C3nB9HSQaKgLzOHEFy9mrD2WW3PRBWU=";
  };
  enet-src = fetchFromGitHub {
    owner = "cgutman";
    repo = "enet";
    rev = "44c85e16279553d9c052e572bcbfcd745fb74abf";
    hash = "sha256-lXCZhpy1FgFsUOcdd9fS9HpPZGKW/FTKaKfOOn5J/5g=";
  };
  nanors-src = fetchFromGitHub {
    owner = "sleepybishop";
    repo = "nanors";
    rev = "19f07b513e924e471cadd141943c1ec4adc8d0e0";
    hash = "sha256-lpEDW5JZmFMPdJlS0/2a4MZU68dt7lz633ymbuSUyBc=";
  };
  peglib-src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-peglib";
    rev = "v1.8.5";
    hash = "sha256-GeQQGJtxyoLAXrzplHbf2BORtRoTWrU08TWjjq7YqqE=";
  };
  tomlplusplus-src = fetchFromGitHub {
    owner = "marzer";
    repo = "tomlplusplus";
    rev = "v3.4.0";
    hash = "sha256-h5tbO0Rv2tZezY58yUbyRVpsfRjY3i+5TPkkxr6La8M=";
  };
  cpptrace-src = fetchFromGitHub {
    owner = "jeremy-rifkin";
    repo = "cpptrace";
    rev = "v0.8.2";
    hash = "sha256-3BnAWRpKJR5lsokpmbOLUIQGuiH46AM1NQwOtBl28AA=";
  };
  reflect-cpp-src = fetchFromGitHub {
    owner = "getml";
    repo = "reflect-cpp";
    rev = "v0.21.0";
    hash = "sha256-9D16AoQlb6xHFEpNEMMYHbcW3AUFF7BxPliSkGE7YJU=";
  };
  libdwarf-src = fetchFromGitHub {
    owner = "jeremy-rifkin";
    repo = "libdwarf-lite";
    rev = "v0.11.1";
    hash = "sha256-qHikjAG5xuuHquqqKGuiDHXVZSlg/MbNp9JNSAKM/Hs=";
  };
  simplewebserver-src = fetchFromGitHub {
    owner = "eidheim";
    repo = "Simple-Web-Server";
    rev = "bdb1057";
    hash = "sha256-C9i/CyQG9QsDqIx75FbgiKp2b/POigUw71vh+rXAdyg=";
  };
  zstd-src = fetchFromGitHub {
    owner = "facebook";
    repo = "zstd";
    rev = "v1.5.7";
    hash = "sha256-tNFWIT9ydfozB8dWcmTMuZLCQmQudTFJIkSr0aG7S44=";
  };
in
  stdenv.mkDerivation {
    pname = "wolf";
    version = "1.0";
    src = fetchFromGitHub {
      owner = "games-on-whales";
      repo = "wolf";
      rev = "2f790f6";
      hash = "sha256-2mS16Kq/PlxhAk4yNxZn4NBmR+WgcAkrxRym8bjFuTs=";
    };

    patches = [
      ./wayland-socket-fullpath.patch
    ];

    nativeBuildInputs = [cmake pkg-config ninja makeWrapper];

    buildInputs = [
      boost187
      cudaPackages.cuda_nvrtc
      curl
      elfutils
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
      icu
      libevdev
      libpulseaudio
      libsysprof-capture
      libunwind
      openssl
      orc
      pciutils
      pcre2
      udev
      zstd
    ];

    cmakeFlags = [
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CPPTRACE" "${cpptrace-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FMTLIB" "${fmtlib-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMMER" "${immer-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBDWARF" "${libdwarf-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RANGE" "${range-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TOMLPLUSPLUS" "${tomlplusplus-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ZSTD" "${zstd-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_BOOST_JSON" "${boost-json-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ENET" "${enet-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_EVENTBUS" "${eventbus-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_INPUTTINO" "${inputtino-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MDNS_CPP" "${mdns-cpp-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_NANORS" "${nanors-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PEGLIB" "${peglib-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_REFLECT-CPP" "${reflect-cpp-src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SIMPLEWEBSERVER" "${simplewebserver-src}")
      (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
      (lib.cmakeBool "BUILD_SHARED_LIBS" false)
      (lib.cmakeBool "BUILD_TESTING" false)
      "-G Ninja"
    ];

    buildPhase = "ninja wolf";

    installPhase = ''
      mkdir -p $out/bin
      cp ./src/moonlight-server/wolf $out/bin/wolf
    '';

    preFixup = let
      GST_PLUGIN_PATH = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
        gst-interpipe
        gst-wayland-display
        gst_all_1.gst-libav
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-vaapi
      ];
    in ''
      wrapProgram $out/bin/wolf \
        --prefix GST_PLUGIN_PATH : "${GST_PLUGIN_PATH}" \
        --set WOLF_DOCKER_FAKE_UDEV_PATH "${lib.getExe' fake-udev "fake-udev"}"
    '';
  }
