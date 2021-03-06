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
(menu-bar-mode -1)
(tool-bar-mode -1)
(load-theme 'zerodark t)
(setq-default tab-width 4)
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(global-auto-revert-mode t)
(column-number-mode)
(global-linum-mode)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
(global-hl-line-mode 1)
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
   '(("." . "~/.emacs_backup/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)
;; Ivy Completion Framwork
(use-package ivy
:ensure t
:config
(ivy-mode 1)
(setq ivy-count-format "(%d/%d) ")
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))
;; Company
(use-package company
:config
(add-hook 'after-init-hook 'global-company-mode)
(add-to-list 'company-backends 'company-nixos-options)
(add-to-list 'company-backends 'company-anaconda))
;; Nix Mode
(use-package nix-mode
  :mode ("\\.nix\\'" "\\.nix.in\\'"))
(use-package nix-drv-mode
  :ensure nix-mode
  :mode "\\.drv\\'")
(use-package nix-shell
  :ensure nix-mode
  :commands (nix-shell-unpack nix-shell-configure nix-shell-build))
(use-package nix-repl
  :ensure nix-mode
  :commands (nix-repl))
;; Haskell Mode
(use-package dante
  :ensure t
  :after haskell-mode
  :commands 'dante-mode
  :init
  (add-hook 'haskell-mode-hook 'flycheck-mode)
  ;; OR:
  ;; (add-hook 'haskell-mode-hook 'flymake-mode)
  (add-hook 'haskell-mode-hook 'dante-mode)
;;  (setq dante-repl-command-line '("nix-shell" "--run" "cabal new-repl"))
  )
;; Direnv Mode
(use-package direnv
 :config
 (direnv-mode))
;; FlyCheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
;; Python
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

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
  
  use-package  # ;
  
  ivy          # ; Incremental Completion Framework
  counsel
  swiper

  company                       # ;Completion Framework
  company-nixos-options
  company-anaconda

  haskell-mode
  dante

  direnv

  flycheck

  anaconda-mode
  pythonic

  
  ]) ++ [
    pkgs.notmuch   # From main packages set 
  ])
    
