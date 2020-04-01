;; Packages list needed--------------------------
(setq elisp-package-list '(;;ui complete
                           company

                           ;;common utils
                           ws-butler autopair

                           ;;code complete
                           company-quickhelp
                           ))
(use-package elisp-mode
  :ensure nil

  :bind
  (
   :map lisp-mode-map
        ([remap electric-newline-and-maybe-indent] . xref-find-definitions)
        ("M-j" . xref-pop-marker-stack)
   )

  :config

  ;; install the missing packages
  (dolist (package elisp-package-list)
    (unless (package-installed-p package)
      (package-install package)))

  (defun tserg/elisp-mode-common-hook()
    (ws-butler-mode 1)
    (whitespace-mode 1)
    (hs-minor-mode 1)
    (toggle-truncate-lines nil)
    (setq-local auto-hscroll-mode 'current-line);;emacs version >= 26

    (font-lock-mode t)
    (setq font-lock-maximum-decoration t)

    (add-to-list (make-local-variable 'company-backends)
                 '(company-elisp))
    )

  (add-hook 'emacs-lisp-mode-hook 'tserg/elisp-mode-common-hook)
  )
