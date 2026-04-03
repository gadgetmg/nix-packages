{
  autoPatchelfHook,
  cmake,
  fetchFromGitHub,
  ninja,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "fake-udev";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "games-on-whales";
    repo = "wolf";
    rev = "stable";
    hash = "sha256-4amq0zxc4R4CAobTqoOHd0I9+34U6VbcIgI5Q3gcWQc=";
  };

  sourceRoot = "${src.name}/src/fake-udev";

  postPatch = ''
    mv CMakeLists.txt CMakeLists.txt.old
    cat << EOF > CMakeLists.txt
    cmake_minimum_required(VERSION 3.13...3.24)

    # Project name and a few useful settings. Other commands can pick up the results
    project(fake-udev
            VERSION 0.1
            DESCRIPTION "Howling under the Moonlight"
            LANGUAGES CXX)
    EOF
    cat CMakeLists.txt.old >> CMakeLists.txt
    rm CMakeLists.txt.old
  '';

  nativeBuildInputs = [cmake pkg-config ninja autoPatchelfHook];

  buildInputs = [stdenv.cc.libc.static];

  cmakeFlags = ["-G Ninja"];

  buildPhase = ''
    ninja fake-udev
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./fake-udev $out/bin/fake-udev
  '';
}
