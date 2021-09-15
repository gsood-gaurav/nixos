self: super:
with super; {
myPackages = buildEnv {
name = "my-packages";
paths = [
  direnv
  google-chrome
  gitFull
  gnomeExtensions.dash-to-dock
  texlive.combined.scheme-full
  libreoffice
  ccls
  nix-prefetch-git
  nix-prefetch-github
  jupyter
];
};
}
