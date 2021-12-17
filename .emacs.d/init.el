(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default))
)

;; (defvar last-file-name-handler-alist file-name-handler-alist)
;; (setq gc-cons-threshold 402653184
;;       gc-cons-percentage 0.6
;;       file-name-handler-alist nil)

(when (eval-when-compile (version< "28" emacs-version ))
  (setq-default native-comp-async-report-warnings-errors 'silent))




;;Package--------------------------------------------------
(require 'package)
;; (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))


(package-initialize)
; fetch the list of packages available
(unless package-archive-contents
  (message "Refresing package repository")
  (package-refresh-contents))
(when (eval-when-compile (version< emacs-version "27"))
  (package-initialize))

(defmacro k-time (&rest body)
  "Measure and return the time it takes evaluating BODY."
  `(let ((time (current-time)))
     ,@body
     (float-time (time-since time))))

;; ; fetch the list of packages available
(unless package-archive-contents
  (message "Refresing package repository %.06fsec" (k-time (package-refresh-contents)))
  )

;; install the missing packages

(message "common_conf takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/common_conf.el")));; common-hook
(message "elisp_conf takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/elisp_conf.el")));; elisp-mode
(message "compilation_config takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/compilation_config.el")));; compilation-mode
(message "logs_config takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/logs_config.el")));; logs-mode

(message "js_config takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/js_config.el")));; json configs
(message "python_conf takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/python_conf.el")));; pythons configs
(message "rust_config takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/rust_config.el")));; rust configs
(message "go_config takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/go_config.el")));; go configs
(message "qml_config takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/qml_config.el")));; qml-mode

(message "c++_config takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/c++_config.el")));; c-mode
(load "~/.emacs.d/rc/qt_config.el");; qt-mode

(message "latex_config takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/latex_config.el")));; latex-mode
;; (load "~/.emacs.d/rc/fb_config.el");; fbread-mode
(message "org_config takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/org_config.el")));; org-mode
(message "R_config takes %.02fsec to load" (k-time (load "~/.emacs.d/rc/R_config.el")));; R-lang-mode

(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(setq gc-cons-threshold 4000000)

;; (defun my/set-gc-threshold ()
;;   "Reset `gc-cons-threshold' to its default value."
;;   (setq gc-cons-threshold 16777216 ;; 800000
;;         gc-cons-percentage 0.4)

;;   ;; When idle for 15sec run the GC no matter what.
;;   (defvar k-gc-timer
;;     (run-with-idle-timer 15 t
;;                          (lambda ()
;;                            (message "Garbage Collector has run for %.06fsec"
;;                                     (k-time (garbage-collect))))))
;;   )
;; (add-hook 'emacs-startup-hook 'my/set-gc-threshold)

;; (message "*** Emacs loaded in %s with %d garbage collections."
;;      (format "%.2f seconds"
;;              (float-time
;;               (time-subtract after-init-time before-init-time))) gcs-done)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-error-list-highlight ((t (:inherit highlight :background "#504b4b")))))

(provide 'init)
