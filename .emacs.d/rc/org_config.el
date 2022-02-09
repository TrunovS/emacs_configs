(use-package org
  :ensure nil
  :ensure ob-async
  :ensure ob-http
  :ensure ob-restclient

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

  ;; (require 'ob-python)
  (require 'ob-async)
  ;; (require 'ox-latex)

  (defun org-babel-execute:js (body params)
    (let ((jq (cdr (assoc :jq params)))
          )
      (with-temp-buffer
          ;; Insert the JSON into the temp buffer
          (insert body)
          ;; Run jq command on the whole buffer, and replace the buffer
          ;; contents with the result returned from jq
          (shell-command-on-region (point-min) (point-max) (format "jq -r \"%s\"" jq) nil 't)
          ;; Return the contents of the temp buffer as the result
          (buffer-string))
      ))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     ;; (ipython . t)
     (shell . t)
     (latex . t)
     (R . t)
     (http . t)
     (restclient . t)
     )
   )
  (setq
   ;; Fix an incompatibility ob-async and ob-ipython packages
   ;; ob-async-no-async-languages-alist '("ipython")
        org-export-odt-preferred-output-format "docx"
        org-odt-preferred-output-format "docx"
        org-startup-folded t
        org-log-done t
        org-src-fontify-natively t
        org-confirm-babel-evaluate nil
        org-directory "~/org-docs"
        org-babel-remote-temporary-directory "~/org_tmp"
        )

  (defvar org-blocks-hidden nil)

  (cond ((< emacs-major-version 27)
         (set-face-attribute 'org-block nil
                             :foreground nil
                             :background (color-darken-name (face-background 'default) 5))
         (set-face-attribute 'org-code nil
                             :foreground nil
                             :background (color-darken-name (face-background 'default) 5))
         )
        (t
         (set-face-attribute 'org-block-begin-line nil
                             :foreground nil
                             :overline "black"
                             :background (color-lighten-name (face-background 'default) 5)
                             :extend t)
         (set-face-attribute 'org-block-end-line nil
                             :foreground nil
                             :overline nil
                             :underline "black"
                             :background (color-lighten-name (face-background 'default) 5)
                             :extend t)
         (set-face-attribute 'org-meta-line nil
                             :foreground nil
                             :background (color-lighten-name (face-background 'default) 5)
                             :extend t)
         (set-face-attribute 'org-block nil
                             :foreground nil
                             :background (color-darken-name (face-background 'default) 5)
                             :extend t)
         (set-face-attribute 'org-code nil
                             :foreground nil
                             :background (color-darken-name (face-background 'default) 5)
                             :extend t)
        ))

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
    ;; (toggle-truncate-lines -1)
    (visual-line-mode 1)
    )

  (add-hook 'doc-view-mode-hook 'auto-revert-mode)
  (add-hook 'org-mode-hook 'tserg/org-mode-hook)
  )
