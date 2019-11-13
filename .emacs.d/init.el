(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default)))
 )

;;Package--------------------------------------------------
(require 'package)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(setq package-list '(;;theme specific
                     auto-dim-other-buffers smart-mode-line nova-theme

                     ;;project management
                     projectile projectile-ripgrep counsel-projectile

                     ;;ui complete
                     ivy ivy-posframe counsel
                     company

                     ;;common utils
                     uuidgen exec-path-from-shell google-this ws-butler iedit fuzzy autopair
                     pdf-tools flymake-cursor smart-tabs-mode
                     yasnippet yasnippet-snippets yasnippet-classic-snippets
                     dumb-jump nav xterm-color interleave
                     flycheck

                     ;;VCS management
                     ahg magit

                     ;;custom modes
                     logview dockerfile-mode undo-tree
                     qt-pro-mode qml-mode ;Qt
                     rust-mode ;Rust
                     lsp-mode lsp-ui ;Language Server Protocol

                     ;;code complete
                     company-quickhelp company-lsp
                     company-c-headers ;C
                     company-qml ;QML
                     ac-racer racer ;Rust
                     pyvenv jedi ;Python
                     go-eldoc ;go docs
                     ess ess-R-data-view ;R
                     ;; org mode babels
                     ob-async ob-http ob-ipython
                     dash))

;; (add-to-list 'package-archives '("melpa" . "https://elpa.zilongshanren.com/melpa/") t)
;; (add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(load "~/.emacs.d/rc/common_conf.el");; common-hook
(load "~/.emacs.d/rc/compilation_config.el");; compilation-mode
(load "~/.emacs.d/rc/logs_config.el");; logs-mode
(load "~/.emacs.d/rc/python_conf.el");; pythons configs
(load "~/.emacs.d/rc/rust_config.el");; rust configs
(load "~/.emacs.d/rc/go_config.el");; go configs
(load "~/.emacs.d/rc/c++_config.el");; c-mode
(load "~/.emacs.d/rc/qt_config.el");; qt-mode
(load "~/.emacs.d/rc/qml_config.el");; qml-mode
(load "~/.emacs.d/rc/latex_config.el");; latex-mode
(load "~/.emacs.d/rc/fb_config.el");; fbread-mode
(load "~/.emacs.d/rc/org_config.el");; org-mode

(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-error-list-highlight ((t (:inherit highlight :background "#504b4b"))))
 '(sml/col-number ((t (:inherit sml/modes)))))

(provide 'init)
