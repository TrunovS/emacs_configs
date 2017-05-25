(defun tserg/latex-mode-hook ()
  (setq get-buffer-compile-command
        (lambda (file) (format "pdflatex %s" file)
          ))
  (auto-complete-mode 1)
  ;; (ac-flyspell-workaround)
  ;; (flyspell-mode 1)
)

(add-hook 'latex-mode-hook 'tserg/latex-mode-hook)
(add-to-list 'auto-mode-alist '("\\.tex\\'" . latex-mode))
