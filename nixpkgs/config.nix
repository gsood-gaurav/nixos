{
  packageOverrides = super: let self = super.pkgs; in {
    myemacs = import ./emacsconfig/emacs.nix { pkgs = self; };
  };
}