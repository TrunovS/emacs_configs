(use-package tex-mode
  :ensure nil

  :mode
  ("\\.tex\\'" . latex-mode)

  :no-require t
  :defer t

  :config

  (defun tserg/latex-mode-hook ()
    (setq get-buffer-compile-command
          (lambda (file) (format "pdflatex %s" file)
            ))
    ;; (ac-flyspell-workaround)
    ;; (flyspell-mode 1)
    )

  (add-hook 'latex-mode-hook 'tserg/latex-mode-hook)
  )
