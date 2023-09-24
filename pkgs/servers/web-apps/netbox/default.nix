{ lib, nixosTests, callPackage, }:
let
  generic = import ./generic.nix;
in
lib.fix (self: {
  netbox = self.netbox_3_6;

  netbox_3_5 = callPackage generic {
    version = "3.5.9";
    hash = "sha256-CJbcuCyTuihDXrObSGyJi2XF+zgWAwcJzjxtkX8pmKs=";
    extraPatches = [
      # Allow setting the STATIC_ROOT from within the configuration and setting a custom redis URL
      ./config.patch
    ];
    tests = {
      netbox = nixosTests.netbox_3_5;
      inherit (nixosTests) netbox-upgrade;
    };

    maintainers = with lib.maintainers; [ minijackson n0emis raitobezarius ];
    eol = true;
  };

  netbox_3_6 = callPackage generic {
    version = "3.6.2";
    hash = "sha256-iKYzeiaJhF8T+qbft6fS1PjHyPxxQm86om9YpAGnvYE=";
    extraPatches = [
      # Allow setting the STATIC_ROOT from within the configuration and setting a custom redis URL
      ./config.patch
    ];
    tests = {
      netbox = nixosTests.netbox_3_6;
      inherit (nixosTests) netbox-upgrade;
    };

    maintainers = with lib.maintainers; [ minijackson n0emis raitobezarius ];
  };
})
