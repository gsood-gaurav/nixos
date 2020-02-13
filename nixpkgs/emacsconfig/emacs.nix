/*
This is a nix expression to build Emacs and some Emacs packages I like
from source on any distribution where Nix is installed. This will install
all the dependencies from the nixpkgs repository and build the binary files
without interfering with the host distribution.

To build the project, type the following from the current directory:

$ nix-build emacs.nix

To run the newly compiled executable:

$ ./result/bin/emacs
*/
{ pkgs ? import <nixpkgs> {} }: 

let
  myEmacs = pkgs.emacs; 
  emacsWithPackages = (pkgs.emacsPackagesGen myEmacs).emacsWithPackages;
  myEmacsConfig = pkgs.writeText "default.el" ''
(require 'package)
(package-initialize)
(load-theme 'zerodark t)
(setq-default tab-width 4)
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
'';
in
emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
  (pkgs.runCommand "default.el" {} ''
mkdir -p $out/share/emacs/site-lisp
cp ${myEmacsConfig} $out/share/emacs/site-lisp/default.el
'')
  magit          # ; Integrate git <C-x g>
  zerodark-theme # ; Nicolas' theme
  nix-mode	   # ; Nix Mode editing
  ivy          # ; Completion Framework
  vlf          # ; Manipulating very large files
  direnv       # ;
  use-package  # ;
  ]) ++ [
    pkgs.notmuch   # From main packages set 
  ])
    
