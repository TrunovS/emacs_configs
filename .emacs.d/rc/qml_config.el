;; Packages list needed--------------------------
(setq package-list '(qml-mode

                     company
                     company-qml

                     company-quickhelp
                     ))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


(defun tserg/qml-mode-hook ()
  (require 'company-qml)
  (add-to-list (make-local-variable 'company-backends)
               '(company-qml))
  (company-quickhelp-mode 1)
  (define-key c-mode-base-map "\C-j" 'xref-find-definitions)
  (define-key c-mode-base-map "\M-j" 'xref-pop-marker-stack)
  )

(add-to-list 'auto-mode-alist '("\\.qml\\'" . qml-mode-hook))
(add-hook 'qml-mode-hook 'tserg/qml-mode-hook)
