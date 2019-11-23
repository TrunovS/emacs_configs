(setq package-list '(;; org mode babels
                     ob-async ob-http ob-ipython
                     ))


; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


(require 'org)
(require 'ob-python)
(require 'ob-async)
(require 'ox-latex)

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)
    (ipython . t)
    (shell . t)
    (latex . t)
    (R . t)
    (http . t)
    ))

(setq ob-async-no-async-languages-alist '("ipython") ;; Fix an incompatibility ob-async and ob-ipython packages
      org-export-odt-preferred-output-format "docx"
      org-odt-preferred-output-format "docx"
      org-startup-folded nil
      org-log-done t
      org-src-fontify-natively t
      org-confirm-babel-evaluate nil
      org-directory "~/org-docs"
      )

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|/TODO\\)$" . org-mode))
(add-to-list 'file-coding-system-alist (cons "\\.\\(org\\|org_archive\\|/TODO\\)$"  'utf-8))

(defvar org-blocks-hidden nil)

(set-face-attribute 'org-block nil
                    :foreground nil
                    :background (color-darken-name (face-background 'default) 4))
(set-face-attribute 'org-code nil
                    :foreground nil
                    :background (color-darken-name (face-background 'default) 4))

(defun tserg/org-latex-export-to-pdf ()
  (interactive)
    (org-open-file (org-latex-export-to-pdf))
  )

(defun org-toggle-blocks ()
  (interactive)
  (if org-blocks-hidden
      (org-show-block-all)
    (org-hide-block-all))
  (setq-local org-blocks-hidden (not org-blocks-hidden)))

;; PDFs visited in Org-mode are opened in Evince (and not in the default choice) https://stackoverflow.com/a/8836108/789593
(defun tserg/org-mode-hook ()
  (with-eval-after-load 'ox-latex
    ;; (delete '("\\.pdf\\'" . default) org-file-apps)
    ;; (add-to-list 'org-file-apps '("\\.pdf\\'" . "evince %s"))
    ;; (add-to-list 'org-file-apps '("\\.pdf\\'" . "org-pdfview-open"))
    )
  (add-hook 'doc-view-mode-hook 'auto-revert-mode)
  (flyspell-mode 1)
  (define-key org-mode-map (kbd "<f8>") 'tserg/org-latex-export-to-pdf)
  (define-key org-mode-map (kbd "C-c t") 'org-toggle-blocks)
  (define-key org-mode-map (kbd "C-c t") 'org-toggle-blocks)
  (define-key org-mode-map (kbd "C-c x") 'org-babel-execute-buffer)
  (toggle-truncate-lines -1)
  )
 
(add-hook 'org-mode-hook 'tserg/org-mode-hook)
