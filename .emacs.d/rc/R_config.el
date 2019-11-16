(setq package-list '(ess
                     ess-R-data-view
                     ))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))
