(setq R-package-list '(ess
                       ess-R-data-view
                       ))

(use-package ess
  :ensure t
  :no-require t
  :init
  (autoload 'ess-mode "ess")

  :config

  ;; install the missing packages
  (dolist (package R-package-list)
    (unless (package-installed-p package)
      (package-install package)))
  )
