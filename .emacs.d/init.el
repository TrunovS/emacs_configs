(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default)))
 '(desktop-restore-eager 7)
 '(frame-background-mode (quote dark))
 '(global-hl-line-mode t)
 '(grep-command "grep -nH -e ")
 '(grep-find-command
   "grep -rnH --exclude=.hg --include=*.{c,cpp,h,R,qml} --include=-e 'pattern'")
 '(grep-find-template "find . <X> -type f <F> -exec grep <C> -nH -e <R> {} +")
 '(grep-highlight-matches (quote auto))
 '(grep-template "grep <X> <C> -nH -e <R> <F>")
 '(grep-use-null-device nil)
 '(ido-work-directory-match-only t)
 '(jedi:install-python-jedi-dev-command
   (quote
    ("pip3" "install" "--upgrade" "git+https://github.com/davidhalter/jedi.git@dev#egg=jedi")))
 '(nav-boring-file-regexps
   (quote
    ("^[.][^.].*$" "^[.]$" "~$" "[.]elc$" "[.]pyc$" "[.]o$" "[.]bak$" "^_MTN$" "^blib$" "^CVS$" "^RCS$" "^SCCS$" "^_darcs$" "^_sgbak$" "^autom4te.cache$" "^cover_db$" "^_build$" "moc_*" "ui_*")))
 '(org-confirm-babel-evaluate nil)
 '(org-directory "~/org-docs")
 '(org-log-done t)
 '(org-src-fontify-natively t)
 '(org-startup-folded nil)
 '(scroll-bar-mode (quote nil))
 '(show-paren-mode t)
 '(special-display-buffer-names (quote ("*grep*" "*compilation*" "*clang error")))
 '(special-display-regexps nil)
 '(standard-indent 2)
 '(vc-annotate-background "#3C4C55")
 '(vc-annotate-color-map
   (\`
    ((20 \, "#DF8C8C")
     (40 \, "#e2cc97008c99")
     (60 \, "#e699a2008d33")
     (80 \, "#ea66acff8dcc")
     (100 \, "#ee33b8008e66")
     (120 \, "#F2C38F")
     (140 \, "#ed33c7998fcc")
     (160 \, "#e866cc339099")
     (180 \, "#e399d0cc9166")
     (200 \, "#deccd5669233")
     (220 \, "#DADA93")
     (240 \, "#d000d7999300")
     (260 \, "#c5ffd5339300")
     (280 \, "#bc00d2cc9300")
     (300 \, "#b200d0669300")
     (320 \, "#A8CE93")
     (340 \, "#a099c7cca366")
     (360 \, "#9933c199b3cc")
     (380 \, "#91ccbb66c433")
     (400 \, "#8a66b533d499")
     (420 \, "#83AFE5")
     (440 \, "#8799a966e433")
     (460 \, "#8c33a3cce366")
     (480 \, "#90cc9e33e299")
     (500 \, "#95669899e1cc")
     (520 \, "#9A93E1"))))
 '(vc-annotate-very-old-color "#7b337599b400")
 '(whitespace-line-column 90)
 '(whitespace-style (quote (face tabs trailing empty tab-mark lines)))
 '(ws-butler-keep-whitespace-before-point nil))

;;Package--------------------------------------------------
(require 'package)
(setq package-list '(nova-theme dockerfile-mode docker smex ob-async ob-ipython pyvenv yasnippet yasnippet-snippets yasnippet-classic-snippets nav google-this xterm-color pdf-tools interleave qt-pro-mode ac-racer racer exec-path-from-shell rust-mode eww-lnum ahg dash w3m company-qml qml-mode magit ws-butler jedi iedit fuzzy flymake-cursor ess ess-R-data-view auto-complete-clang auto-complete-c-headers autopair))

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
(load "~/.emacs.d/rc/python_conf.el");; pythons configs
(load "~/.emacs.d/rc/rust_config.el");; rust configs
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
 '(default ((t (:family "Hack" :foundry "unknown" :slant normal :weight normal :height 98 :width normal))))
 '(cursor ((t (:background "white"))))
 '(ecb-default-highlight-face ((((class color) (background dark)) (:background "#838592"))))
 '(ecb-tag-header-face ((((class color) (background dark)) (:background "#838592"))))
 '(flycheck-error-list-highlight ((t (:inherit highlight :background "#504b4b"))))
 '(header-line ((t (:inherit mode-line :background "dim gray" :foreground "grey90" :box nil))))
 '(highlight ((((class color) (min-colors 88) (background dark)) (:background "#c4c4c4"))))
 '(hl-line ((t (:inherit nil :background "dim gray"))))
 '(region ((t (:background "black"))))
 '(whitespace-line ((t (:overline t)))))

(provide 'init)
