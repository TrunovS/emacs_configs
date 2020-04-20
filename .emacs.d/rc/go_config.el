;; Packages list needed--------------------------
(setq go-package-list '(;;ui complete
                        company

                        ;;common utils
                        ws-butler smart-tabs-mode

                        ;;code complete
                        company-lsp company-quickhelp
                        go-eldoc ;go docs
                        ag ;silver searcher
                        ))

(use-package go-mode
  :ensure t ;; auto install on startup only go-mode

  ;;defered config read on .go open
  :no-require t
  :defer t

  :mode ;;mode associassion
  ("\\.mod\\'" . 'fundamental-mode)
  ("\\.go\\'" . 'go-mode)

  :bind ;;HotKeys
  (
   :map go-mode-map
        ([f7] . 'projectile-ag)
        ("C-<f7>" . 'projectile-grep)
        ("\C-xj" . 'xref-find-definitions)
        ("\C-hj" . 'godoc-at-point)
        )

  :config

  ;; install the missing packages
  (dolist (package go-package-list)
    (unless (package-installed-p package)
      (package-install package)))

  (require 'company-lsp)

  (smart-tabs-add-language-support go go-mode-hook
    ((c-indent-line . c-basic-offset)
     (c-indent-region . c-basic-offset)))

  (smart-tabs-insinuate 'go)

  (defun tserg/go-mode-hook()
    (setq-local tab-width 2)
    (setq-local indent-tabs-mode t)
    (ws-butler-mode 1)
    (whitespace-mode 1)

    (hs-minor-mode 1)
    (toggle-truncate-lines nil)
    ;; (setq-local auto-hscroll-mode 'current-line);;emacs version >= 26
    (font-lock-mode t)
    (setq font-lock-maximum-decoration t)
    (setq godoc-at-point-function (quote godoc-gogetdoc))

    (lsp 1)
    (lsp-ui-mode 1)
    (setq lsp-ui-doc-include-signature nil)  ; don't include type signature in the child frame
    (setq lsp-ui-sideline-enable nil)  ; don't show symbol on the right of info
    (eldoc-mode nil)
    (global-eldoc-mode -1)
    (setq lsp-ui-doc-position (quote top))

    (add-to-list (make-local-variable 'company-backends)
                 '(company-lsp company-files company-abbrev company-dabbrev
                               company-keywords))

    (setq company-transformers nil
          company-lsp-async t
          company-lsp-cache-candidates nil)

    (company-quickhelp-mode)

    ;;  (add-hook 'before-save-hook 'gofmt-before-save)

    ;; Customize compile command to run go build
    (if (not (string-match "go" compile-command))
        (set (make-local-variable 'compile-command)
             "go build -v && go test -v && go vet"))

    )

  (add-hook 'go-mode-hook 'tserg/go-mode-hook)
  )
