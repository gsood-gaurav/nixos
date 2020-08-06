self: super:

let
  myEmacs = super.emacs; 
  emacsWithPackages = (super.emacsPackagesGen myEmacs).emacsWithPackages;
  myEmacsConfig = super.writeText "default.el" ''
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
   (haskell . t)
   (C . t)
   (emacs-lisp . t)
   (scheme . t)
   (shell . t)))

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
(setq lsp-pyls-server-command "/nix/store/famrgkkpmxpbh3wvpxmdyq0cncdfmild-python3.7-python-language-server-0.29.1/bin/pyls")
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
(setq lsp-haskell-process-path-hie "haskell-language-server-wrapper")
(setq lsp-log-io t)
;; lsp-ui
(use-package lsp-ui :commands lsp-ui-mode)
;;(define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
;;(define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)
(push 'company-lsp company-backends)
(setq company-clang-executable "/nix/store/268swz1wq5p8cbbll580vv0mgqm0n4an-clang-wrapper-7.1.0/bin/clang")
;;(use-package company-box
;;  :hook (company-mode . company-box-mode))
(setq lsp-prefer-flymake nil)
(yas-global-mode)
(powerline-default-theme)
(smartparens-global-mode)
(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'scheme-mode-hook 'rainbow-blocks-mode)
(add-to-list 'company-backends 'company-nixos-options)
'';
in
{
myemacs = emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
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
  company-nixos-options
  nixos-options
])
# company quick help throws error in anaconda mode due to melpa stable package anaconda-mode 0.1.12
# function "anaconda-mode-with-text-buffer" was not working. As a workaround all the following
# dependencies needs to be installed from the melpapackages.
++ (with epkgs.melpaPackages; [ pythonic anaconda-mode company-anaconda lsp-mode lsp-ui lsp-haskell company-lsp lsp-ivy lsp-treemacs ccls company-box ])

);
}
