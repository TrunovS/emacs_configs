;;El-Get-------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

;;Package--------------------------------------------------
(require 'package)
;; (add-to-list 'package-archives 
;;     '("marmalade" .
;;       "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(package-initialize)

;;Eshell Env----------------------------
(setenv "PATH" (shell-command-to-string ". ~/.profile; echo -n $PATH"))

(load "~/.emacs.d/rc/common_conf.el");; common-hook
(load "~/.emacs.d/rc/python_conf.el");; pythons configs
(load "~/.emacs.d/rc/rust_config.el");; rust configs
(load "~/.emacs.d/rc/c++_config.el");; c-mode
(load "~/.emacs.d/rc/qt_config.el");; qt-mode
(load "~/.emacs.d/rc/qml_config.el");; qml-mode
(load "~/.emacs.d/rc/latex_config.el");; latex-mode
(load "~/.emacs.d/rc/fb_config.el");; fbread-mode

(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)

;;Flymake Settings ------------------------------------------------

;; (load "~/.emacs.d/flymake-settings.el")
;; (eval-after-load 'flycheck
;;   '(progn
;;      (require 'flycheck-google-cpplint)
;;      ;; Add Google C++ Style checker.
;;      ;; In default, syntax checked by Clang and Cppcheck.
;;      (flycheck-add-next-checker 'c/c++-clang
;;                                 'c/c++-googlelint 'append)))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compilation-scroll-output (quote first-error))
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
 '(package-selected-packages
   (quote
    (ac-racer racer exec-path-from-shell rust-mode eww-lnum ahg dash w3m company-qml qml-mode magit yasnippet ws-butler jedi iedit fuzzy flymake-cursor flycheck-google-cpplint ess-R-object-popup ess-R-data-view conkeror-minor-mode auto-complete-clang auto-complete-c-headers)))
 '(scroll-bar-mode (quote nil))
 '(show-paren-mode t)
 '(special-display-buffer-names (quote ("*grep*")))
 '(special-display-regexps nil)
 '(standard-indent 4)
 '(truncate-lines t)
 '(whitespace-line-column 90)
 '(whitespace-style
   (quote
    (face tabs trailing indentation empty tab-mark lines)))
 '(ws-butler-keep-whitespace-before-point nil))

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(provide '.emacs)
;;; .emacs ends here

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 98 :width normal))))
 '(cursor ((t (:background "white"))))
 '(ecb-default-highlight-face ((((class color) (background dark)) (:background "#838592"))))
 '(ecb-tag-header-face ((((class color) (background dark)) (:background "#838592"))))
 '(flycheck-error-list-highlight ((t (:inherit highlight :background "#504b4b"))))
 '(header-line ((t (:inherit mode-line :background "dim gray" :foreground "grey90" :box nil))))
 '(highlight ((((class color) (min-colors 88) (background dark)) (:background "#c4c4c4"))))
 '(hl-line ((t (:inherit highlight :background "#504b4b"))))
 '(powerline-active1 ((t (:inherit mode-line :background "grey22" :foreground "gainsboro"))))
 '(region ((t (:background "#3a9890"))))
 '(whitespace-line ((t (:underline t)))))
