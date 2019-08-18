(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default))
   )
 )

;;Package--------------------------------------------------
(require 'package)
(setq package-list '(undo-tree uuidgen smart-tabs-mode logview company company-c-headers company-quickhelp company-lsp flycheck go-eldoc lsp-mode lsp-ui cquery auto-dim-other-buffers smart-mode-line nova-theme dockerfile-mode docker smex ob-async ob-ipython pyvenv yasnippet yasnippet-snippets yasnippet-classic-snippets nav google-this xterm-color pdf-tools interleave qt-pro-mode ac-racer racer exec-path-from-shell rust-mode eww-lnum ahg dash w3m company-qml qml-mode magit ws-butler jedi iedit fuzzy flymake-cursor ess ess-R-data-view auto-complete-clang auto-complete-c-headers autopair))

(add-to-list 'package-archives '("melpa" . "https://elpa.zilongshanren.com/melpa/") t)
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
;; (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;;Projman-------------------------------------------------------
(load-file "~/.emacs.d/projman.el")
(load-file "~/.emacs.d/mode-projman.el")
(projman-mode)

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
