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
(setq package-list '(uuidgen smart-tabs-mode logview company company-quickhelp flycheck auto-dim-other-buffers smart-mode-line nova-theme smex yasnippet yasnippet-snippets yasnippet-classic-snippets nav google-this xterm-color pdf-tools interleave exec-path-from-shell dash magit ws-butler iedit fuzzy flymake-cursor  autopair))

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

(load "~/.emacs.d/rc/common_conf.el");; common-hook

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

