self: super:

let
  myEmacs = self.emacsGcc; 
  emacsWithPackages = ((self.emacsPackagesGen myEmacs).overrideScope' overrides).emacsWithPackages;
  myEmacsConfig = super.writeText "default.el" ''
(require 'package)
(package-initialize)
(menu-bar-mode -1)
(tool-bar-mode -1)
(load-theme 'zerodark t)
(setq-default tab-width 4)
(setq-default fill-column 80)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
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
;; Flycheck
(global-flycheck-mode)
;; Nix Mode
(use-package nix-mode
  :mode ("\\.nix\\'" "\\.nix.in\\'"))
;; Org Mode
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-agenda-files (list "~/Documents/org/agorg/tasks.org" "~/Documents/org/agorg/personal.org"))
(setq org-log-done 'time)
(setq org-log-done 'note)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (ipython . t)
   (haskell . t)
   (C . t)
   (emacs-lisp . t)
   (scheme . t)
   (shell . t)))
(global-set-key (kbd "M-o") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
;; Ivy
(ivy-mode 1)
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "M-y") 'counsel-yank-pop)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "<f2> j") 'counsel-set-variable)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-c v") 'ivy-push-view)
(global-set-key (kbd "C-c V") 'ivy-pop-view)
(global-set-key (kbd "C-c c") 'counsel-compile)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c L") 'counsel-git-log)
(global-set-key (kbd "C-c k") 'counsel-rg)
(global-set-key (kbd "C-c m") 'counsel-linux-app)
(global-set-key (kbd "C-c n") 'counsel-fzf)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-c J") 'counsel-file-jump)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(global-set-key (kbd "C-c w") 'counsel-wmctrl)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "C-c b") 'counsel-bookmark)
(global-set-key (kbd "C-c d") 'counsel-descbinds)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c o") 'counsel-outline)
(global-set-key (kbd "C-c t") 'counsel-load-theme)
(global-set-key (kbd "C-c F") 'counsel-org-file)
;; C++
;; (setq ccls-executable "/nix/store/zbvj02i6gl4x95l6iazrzdjzg2cwhd5d-ccls-0.20190823.5/bin/ccls")
;;(add-hook 'c++-mode-hook 'eglot-ensure)
;;(add-hook 'c-mode-hook 'eglot-ensure)
(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))
(add-hook 'c++-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)
(setq ccls-executable "/nix/store/zbvj02i6gl4x95l6iazrzdjzg2cwhd5d-ccls-0.20190823.5/bin/ccls")
;; Company Mode
(add-hook 'after-init-hook 'global-company-mode)
(company-quickhelp-mode)
;; Anancoda mode
;; (require 'anaconda-mode)
;; (add-hook 'python-mode-hook 'anaconda-mode)
;; (add-hook 'python-mode-hook 'anaconda-eldoc-mode)
(add-hook 'python-mode-hook #'lsp)
;;(setq lsp-pyls-server-command "/nix/store/djzk7nzf3jhi40mq9p7jjy1c9vwdp5fp-python3.8-python-language-server-0.34.1/bin/pyls")
(eval-after-load "company"
 '(add-to-list 'company-backends 'company-anaconda))
(use-package direnv
  :init
  (add-hook 'prog-mode-hook #'direnv-update-environment)
  :config
  (direnv-mode))
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
;; Haskell
(require 'lsp)
(require 'lsp-haskell)
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)
(setq lsp-haskell-process-path-hie "haskell-language-server-wrapper")
;; (setq lsp-log-io t)
;; lsp-ui
(use-package lsp-ui :commands lsp-ui-mode)
;;(define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
;;(define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
;;(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;;(use-package lsp-treemacs :commands lsp-treemacs-errors-list)
;;(push 'company-lsp company-backends)
(setq company-clang-executable "/nix/store/268swz1wq5p8cbbll580vv0mgqm0n4an-clang-wrapper-7.1.0/bin/clang")
;;(use-package company-box
;;  :hook (company-mode . company-box-mode))
(setq lsp-prefer-flymake nil)
;;(setq lsp-file-watch-threshold 8000)
(yas-global-mode)
(powerline-default-theme)
(smartparens-global-mode)
(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'scheme-mode-hook 'rainbow-blocks-mode)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq lsp-headerline-breadcrumb-enable nil)
(lsp-treemacs-sync-mode 1)
(add-to-list 'company-backends 'company-ob-ipython)
(use-package eaf
  :custom
  ; See https://github.com/emacs-eaf/emacs-application-framework/wiki/Customization
  (eaf-browser-continue-where-left-off t)
  (eaf-browser-enable-adblocker t)
  (browse-url-browser-function 'eaf-open-browser)
  :config
  (defalias 'browse-web #'eaf-open-browser))
;;  (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
;;  (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
;;  (eaf-bind-key take_photo "p" eaf-camera-keybinding)
;;  (eaf-bind-key nil "M-q" eaf-browser-keybinding)) ;; unbind, see more in the Wiki
(require 'eaf-browser)

''; 
  overrides = eself: esuper: rec {
    lsp-mode = esuper.lsp-mode.override rec {
      melpaBuild = args: esuper.melpaBuild (args // rec {
        name = "lsp-mode-${version}";
        version = "8.0.0";
        src = (super.fetchFromGitHub {
          repo = "lsp-mode";
          owner = "emacs-lsp";
          rev = "8.0.0";
          sha256="1a6jc9sxf9b8fj9h8xlv5k546bkzsy8j5nj19cfama389z0bzcsl";
        });
      });
    };
    lsp-ui = esuper.lsp-ui.override {
      melpaBuild = args: esuper.melpaBuild (args // rec {
        name = "lsp-ui-${version}";
        version = "8.0.0";
        src = (super.fetchFromGitHub {
          repo = "lsp-ui";
          owner = "emacs-lsp";
          rev = "8.0.0";
          sha256="00yirx6qzlb8fv8rd53zaw93nw72z3br40rb16scdqj1v20qsp47";
        });
      });
    };
    lsp-ivy = esuper.lsp-ivy.override {
      melpaBuild = args: esuper.melpaBuild (args // rec {
        name = "lsp-ivy-${version}";
        version = "0.5";
        src = (super.fetchFromGitHub {
          repo = "lsp-ivy";
          owner = "emacs-lsp";
          rev = "0.5";
          sha256 = "0nb9ypa8hyx7i38rbywh8hn2i5f9l2l567hvdr9767fk279yr97n";
        });
      });
    };
  };
  # my-lsp-mode = super.stdenv.mkDerivation {
  #   name = "lsp-mode";
  #   src = super.fetchFromGitHub {
  #     repo = "lsp-mode";
  #     owner = "emacs-lsp";
  #     rev = "8.0.0";
  #     sha256="1a6jc9sxf9b8fj9h8xlv5k546bkzsy8j5nj19cfama389z0bzcsl";
  #   };
  #   buildInputs = [ myEmacs ] ++ (with super.emacsPackages; [dash f ht lv markdown-mode spinner ]);
  #   buildPhase = ''
  #              ARGS=$(find ${super.lib.concatStrings
  #                (builtins.map (arg: arg + "/share/emacs/site-lisp ") [ myEmacs ] )} \
  #                              -type d -exec echo -L {} \;)
  #   mkdir $out                 
  #   export HOME=$out
  #   ${myEmacs}/bin/emacs -Q -nw -L . $ARGS --batch -f batch-byte-compile *.el
  # '';
  # installPhase = ''
  #   mkdir -p $out/share/emacs/site-lisp
  #   install *.el* $out/share/emacs/site-lisp
  # '';
  # meta = {
  #   description = "Emacs projects from the Internet that just compile .el files";
  #   homepage = http://www.emacswiki.org;
  #   platforms = super.lib.platforms.all;
  # };
  # };

  # lsp-mode = super.emacsPackages.trivialBuild {
  #   pname = "lsp-mode";
  #   version = "8.0.0";
  #   src = super.fetchFromGitHub {
  #     repo = "lsp-mode";
  #     owner = "emacs-lsp";
  #     rev = "8.0.0";
  #     sha256="1a6jc9sxf9b8fj9h8xlv5k546bkzsy8j5nj19cfama389z0bzcsl";
  #   };
  #   emacs = myEmacs;
  #   buildInputs = with super.emacsPackages; [dash f ht lv markdown-mode spinner];
  # };
  # mac-classic-theme = super.emacsPackages.trivialBuild {
  #   pname = "mac-classic-theme";
    
  #   src = super.fetchurl {
  #     url = 
  #     "https://raw.githubusercontent.com/ahobson/mac-classic-theme/master/mac-classic-theme.el";
  #     sha256 = 
  #     "18sm566y11vf2j5rrnkwdh32hd7lwqz6kjy1nx89vx1rjv752x9v";
  #   };
  #   emacs = myEmacs;
  # };

  eaf-browser = self.emacsPackages.trivialBuild rec {
    pname = "eaf-browser";
    version = "1.0";
    src = super.fetchFromGitHub {
      repo = "eaf-browser";
      owner = "emacs-eaf";
      rev = "aa4b9b089c76ff91e0c8ccb5a1a8c2f8b816ec89";
      sha256 = "041mbdwqplxfnrfgywv5py5awr7la1k905pj066ifzfcy9gfwm7c";
    };
    nativeBuildInputs = [super.qt5.wrapQtAppsHook];
    buildInputs = [super.qt5.qtbase super.emacsPackages.aria2];
    buildPhase =
      ''
         mkdir -p $out/share/emacs/site-lisp/elpa/${pname}-${version}/eaf-browser
         find ./ -name "*.el" -type f -print0 | xargs -0 -I "{}" install "{}" $out/share/emacs/site-lisp/elpa/${pname}-${version}/eaf-browser
         find ./ -name "*.py" -type f -print0 | xargs -0 -I "{}" install "{}" $out/share/emacs/site-lisp/elpa/${pname}-${version}/eaf-browser
'';
    installPhase = ''
                 echo ""
                 export QT_QPA_PLATFORM_PLUGIN_PATH="${super.qt5.qtbase.bin}/lib/qt-${super.qt5.qtbase.version}/plugins";

'';

  };

  eaf-application-framework = self.emacsPackages.trivialBuild rec {
    pname = "emacs-application-framework";
    version = "1.0";
    src = super.fetchFromGitHub {
      repo = "emacs-application-framework";
      owner = "emacs-eaf";
      rev = "962a3b98e01406f91cf12119ceb0671a6b7e097a";
      sha256 = "0rxmlw04gfb7gylcdy6f2fdrmp8j6ap4f2qsai0j55imwpp7w9lb";
    };
    buildInputs = [super.emacsPackages.aria2 super.python3 super.python3Packages.pyqt5_with_qtwebkit ];
    propagatedbuildInputs = [super.python3 super.python3Packages.pyqt5_with_qtwebkit ];
    buildPhase =
      ''
         mkdir -p $out/share/emacs/site-lisp/elpa/${pname}-${version}/emacs-application-framework
         find ./ -name "*.el" -type f -print0 | xargs -0 -I "{}" install "{}" $out/share/emacs/site-lisp/elpa/${pname}-${version}/emacs-application-framework
         find ./ -name "*.py" -type f -print0 | xargs -0 -I "{}" install "{}" $out/share/emacs/site-lisp/elpa/${pname}-${version}/emacs-application-framework
         cp -r core $out/share/emacs/site-lisp/elpa/${pname}-${version}/emacs-application-framework
'';
    installPhase = ''
                 echo ""
                 export QT_QPA_PLATFORM_PLUGIN_PATH="${super.qt5.qtbase.bin}/lib/qt-${super.qt5.qtbase.version}/plugins";

'';
  };

in
{
myemacs = emacsWithPackages (epkgs: (with epkgs; [
  (super.runCommand "default.el" {} ''
  mkdir -p $out/share/emacs/site-lisp
  cp ${myEmacsConfig} $out/share/emacs/site-lisp/default.el
  '')                 
  magit          # ; Integrate git <C-x g>
  
  zerodark-theme # ; Nicolas' theme
  
  nix-mode	   # ; Nix Mode editing
  
  use-package  # ;
  
  haskell-mode
  ivy
  flycheck
  counsel
  swiper
  eglot
  ein
  company
  company-quickhelp
  direnv
  counsel-projectile
  yasnippet
  yasnippet-snippets
  powerline
  smartparens
  rainbow-delimiters
  rainbow-blocks
  rainbow-identifiers
  org-bullets
  org-beautify-theme
  lsp-mode
  lsp-ui
  lsp-treemacs
  lsp-ivy
  lsp-haskell
  pythonic
  anaconda-mode
  company-anaconda
  ccls
  company-box
  highlight-indent-guides
  ob-ipython
  exwm
  google-this
])
# company quick help throws error in anaconda mode due to melpa stable package anaconda-mode 0.1.12
# function "anaconda-mode-with-text-buffer" was not working. As a workaround all the following
# dependencies needs to be installed from the melpapackages.
# ++ (with epkgs.melpaPackages; [
#   lsp-haskell
#   pythonic
#   anaconda-mode
#   company-anaconda
#   ccls
#   company-box
#   highlight-indent-guides
#   ob-ipython
# ])
++ [
  eaf-browser
  eaf-application-framework
   ]
);
  }
