;; Packages list needed--------------------------
(setq qml-package-list '(qml-mode

                         company-qml
                         ))

(use-package qml-mode
  :ensure t

  :no-require t
  :defer t

  :mode
  ("\\.qml\\'" . qml-mode)

  :bind
  ("\C-j" . 'xref-find-definitions)
  ("\M-j" . 'xref-pop-marker-stack)

  :config

  (autoload 'qml-mode "qml-mode")
  (eval-after-load 'qml
    '(progn
       ;; install the missing packages
       (dolist (package qml-package-list)
         (unless (package-installed-p package)
           (package-install package)))

       (require 'company-qml)

       (defun tserg/qml-mode-hook ()
         (add-to-list (make-local-variable 'company-backends)
                      '(company-qml))
         (company-quickhelp-mode 1)
         )

       (add-hook 'qml-mode-hook 'tserg/qml-mode-hook)
       )
    )
)
