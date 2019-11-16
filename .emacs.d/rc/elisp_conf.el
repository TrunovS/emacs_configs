;; Packages list needed--------------------------
(setq package-list '(;;ui complete
                     company

                     ;;common utils
                     ws-butler autopair

                     ;;code complete
                     company-quickhelp
                     ))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))



(defun tserg/elisp-mode-common-hook()
  (whitespace-mode 1)
  (hs-minor-mode 1)
  (toggle-truncate-lines nil)
  (setq-local auto-hscroll-mode 'current-line);;emacs version >= 26

  (font-lock-mode t)
  (setq font-lock-maximum-decoration t)

  (require 'company-lsp)
  (add-to-list (make-local-variable 'company-backends)
               '(company-elisp))
  )

(add-hook 'emacs-lisp-mode-hook 'tserg/elisp-mode-common-hook)


