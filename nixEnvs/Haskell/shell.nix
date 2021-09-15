with import <nixpkgs> {};

mkShell rec {
  name = "haskell-shell";
  # myGHC = haskellPackages.ghcWithPackages (pkgs: with pkgs; [ cabal-install random ]);
  myGHC = haskell.packages.ghc8104.ghcWithPackages (pkgs: with pkgs; [ cabal-install random haskell-language-server ]);
  buildInputs = [ myGHC ];

  shellHook = ''
'';
}
