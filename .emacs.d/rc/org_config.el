(custom-set-variables
 '(org-startup-folded nil)
 '(org-log-done t)
 '(org-src-fontify-natively t)
 '(org-confirm-babel-evaluate nil)
 '(org-directory "~/org-docs")
 )

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
    ))

;; Fix an incompatibility between the ob-async and ob-ipython packages
(setq ob-async-no-async-languages-alist '("ipython"))

(setq org-export-odt-preferred-output-format "docx")
(setq org-odt-preferred-output-format "docx")

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|/TODO\\)$" . org-mode))
(add-to-list 'file-coding-system-alist (cons "\\.\\(org\\|org_archive\\|/TODO\\)$"  'utf-8))

(defvar org-blocks-hidden nil)

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
  (auto-complete-mode 1)
  (ac-flyspell-workaround)
  (define-key org-mode-map (kbd "<f8>") 'tserg/org-latex-export-to-pdf)
  (define-key org-mode-map (kbd "C-c t") 'org-toggle-blocks)
  (define-key org-mode-map (kbd "C-c t") 'org-toggle-blocks)
  (define-key org-mode-map (kbd "C-c x") 'org-babel-execute-buffer)
  (toggle-truncate-lines -1)
  (ac-auto-start)
  )
  
(add-hook 'org-mode-hook 'tserg/org-mode-hook)
