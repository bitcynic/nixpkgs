{ lib
, fetchFromGitHub
, fetchurl
, buildDunePackage
, ocaml
, gen
, ppxlib
, uchar
}:

let
  unicodeVersion = "15.0.0";
  baseUrl = "https://www.unicode.org/Public/${unicodeVersion}";

  DerivedCoreProperties = fetchurl {
    url = "${baseUrl}/ucd/DerivedCoreProperties.txt";
    sha256 = "sha256-02cpC8CGfmtITGg3BTC90aCLazJARgG4x6zK+D4FYo0=";
  };
  DerivedGeneralCategory = fetchurl {
    url = "${baseUrl}/ucd/extracted/DerivedGeneralCategory.txt";
    sha256 = "sha256-/imkXAiCUA5ZEUCqpcT1Bn5qXXRoBhSK80QAxIucBvk=";
  };
  PropList = fetchurl {
    url = "${baseUrl}/ucd/PropList.txt";
    sha256 = "sha256-4FwKKBHRE9rkq9gyiEGZo+qNGH7huHLYJAp4ipZUC/0=";
  };
in
buildDunePackage rec {
  pname = "sedlex";
  version = "2.6";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = "sedlex";
    rev = "v${version}";
    sha256 = "sha256-AU+dV+jTG9v3BXzip2Bnv04Ewyo3pyUglDDBFsOsFf0=";
  };

  propagatedBuildInputs = [
    gen uchar ppxlib
  ];

  preBuild = ''
    rm src/generator/data/dune
    ln -s ${DerivedCoreProperties} src/generator/data/DerivedCoreProperties.txt
    ln -s ${DerivedGeneralCategory} src/generator/data/DerivedGeneralCategory.txt
    ln -s ${PropList} src/generator/data/PropList.txt
  '';

  doCheck = true;

  dontStrip = true;

  meta = {
    homepage = "https://github.com/ocaml-community/sedlex";
    changelog = "https://github.com/ocaml-community/sedlex/raw/v${version}/CHANGES";
    description = "An OCaml lexer generator for Unicode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.marsam ];
  };
}
