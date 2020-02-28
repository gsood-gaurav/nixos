{
  packageOverrides = pkgs: with pkgs; rec {
    myemacs = import ./emacs.nix { inherit pkgs; };
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
      direnv
      chromium
      myemacs
      gnomeExtensions.dash-to-dock
      ];
    };
  };

  allowUnfree = true;
}
