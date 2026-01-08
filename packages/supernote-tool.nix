{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

let
  potracer = python3Packages.buildPythonPackage {
    pname = "potracer";
    version = "0.0.4";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "tatarize";
      repo = "potrace";
      rev = "8d8a6780743e09204aa8a355993016aeba383c62";
      hash = "sha256-afK7NdpxNm+lCN2i2h5V52AiE3uUiYRtbSYSzcKL2sc=";
    };

    build-system = [
      python3Packages.setuptools
    ];

    propagatedBuildInputs = [
      python3Packages.numpy
    ];
  };
in

python3Packages.buildPythonApplication rec {
  pname = "supernote-tool";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jya-dev";
    repo = "supernote-tool";
    rev = "853e4aa1b3094a3c4384d2eae725bad2fe7e69c5";
    hash = "sha256-EKfhg0puWu41cY3v+cV1f/0eel08sOAFf5tx+csFO1g=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  propagatedBuildInputs = with python3Packages; [
    colour
    fusepy
    numpy
    pillow
    potracer
    pypng
    reportlab
    svglib
    svgwrite
  ];
}
