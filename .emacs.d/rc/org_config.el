(setq org-package-list '(;; org mode babels
                         ob-async ob-http
                                  ;; ob-ipython ;this causes load of python mode in setup
                         ))

(use-package org
  :ensure nil
  :no-require t ;;defered config read
  :defer t ;;defered config read

  :mode ;;mode associassion
  ("\\.\\(org\\|org_archive\\|/TODO\\)$" . org-mode)

  :bind ;;HotKeys
  (
   :map org-mode-map
        ([f8] . 'tserg/org-latex-export-to-pdf)
        ("C-c t" . 'org-toggle-blocks)
        ("C-c x" . 'org-babel-execute-buffer)
        
        ("S-<left>" . nil)
        ("S-<right>" . nil)
        ("S-<up>" . nil)
        ("S-<down>" . nil)
        
        ("M-<left>" . nil)
        ("M-<right>" . nil)
        ("M-<up>" . nil)
        ("M-<down>" . nil)
        )

  :init
  (autoload 'org-mode "org") ;;load only when necessary
  (add-to-list 'file-coding-system-alist (cons "\\.\\(org\\|org_archive\\|/TODO\\)$"  'utf-8))

  :config

  ;; install the missing packages
  (dolist (package org-package-list)
    (unless (package-installed-p package)
      (package-install package)))

  ;; (require 'ob-python)
  (require 'ob-async)
  ;; (require 'ox-latex)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     ;; (ipython . t)
     (shell . t)
     (latex . t)
     (R . t)
     (http . t)
     ))

  (setq
   ;; Fix an incompatibility ob-async and ob-ipython packages
   ;; ob-async-no-async-languages-alist '("ipython")
        org-export-odt-preferred-output-format "docx"
        org-odt-preferred-output-format "docx"
        org-startup-folded nil
        org-log-done t
        org-src-fontify-natively t
        org-confirm-babel-evaluate nil
        org-directory "~/org-docs"
        org-babel-remote-temporary-directory "~/org_tmp"
        )

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

  (defun tserg/org-mode-hook ()
    ;; (with-eval-after-load 'ox-latex)
    ;; PDFs visited in Org-mode are opened in Evince (and not in the default choice) https://stackoverflow.com/a/8836108/789593
    ;; (delete '("\\.pdf\\'" . default) org-file-apps)
    ;; (add-to-list 'org-file-apps '("\\.pdf\\'" . "evince %s"))
    ;; (add-to-list 'org-file-apps '("\\.pdf\\'" . "org-pdfview-open"))
    (flyspell-mode 1)
    (toggle-truncate-lines -1)
    )

  (add-hook 'doc-view-mode-hook 'auto-revert-mode)
  (add-hook 'org-mode-hook 'tserg/org-mode-hook)
  )
