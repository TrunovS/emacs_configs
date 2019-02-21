;;Package--------------------------------------------------
(require 'package)
(setq package-list '(nova-theme dockerfile-mode docker smex ob-async ob-ipython pyvenv yasnippet yasnippet-snippets yasnippet-classic-snippets nav google-this xterm-color pdf-tools interleave qt-pro-mode ac-racer racer exec-path-from-shell rust-mode eww-lnum ahg dash w3m company-qml qml-mode magit ws-butler jedi iedit fuzzy flymake-cursor ess ess-R-data-view auto-complete-clang auto-complete-c-headers autopair))

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
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

(load-theme 'nova t)

;; Set Path----------------------------------
(exec-path-from-shell-initialize)
(setenv "PYTHONIOENCODING" "utf-8")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(desktop-restore-eager 7)
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
 '(scroll-bar-mode (quote nil))
 '(show-paren-mode t)
 '(special-display-buffer-names (quote ("*grep*" "*compilation*" "*clang error")))
 '(special-display-regexps nil)
 '(standard-indent 2)
 '(truncate-lines t)
 '(whitespace-line-column 90)
 '(whitespace-style (quote (face tabs trailing empty tab-mark lines)))
 '(ws-butler-keep-whitespace-before-point nil))

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
 '(mode-line ((t (:background "#30003ccc4400" :foreground "#7FC1CA" :box (:line-width 2 :color "grey75" :style released-button)))))
 '(region ((t (:background "black"))))
 '(whitespace-line ((t (:overline t)))))

(provide 'init)
