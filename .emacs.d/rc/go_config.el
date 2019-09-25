(defun tserg/go-mode-hook()
  (setq-local tab-width 2)
  (ws-butler-mode)
  (whitespace-mode)

  (hs-minor-mode)
  (toggle-truncate-lines nil)
  (setq-local auto-hscroll-mode 'current-line);;emacs version >= 26
  (font-lock-mode t)
  (setq font-lock-maximum-decoration t)
  (setq godoc-at-point-function (quote godoc-gogetdoc))


  (lsp)
  (lsp-ui-mode)
  (setq lsp-ui-doc-include-signature nil)  ; don't include type signature in the child frame
  (setq lsp-ui-sideline-enable nil)  ; don't show symbol on the right of info
  (eldoc-mode nil)
  (global-eldoc-mode -1)
  (setq lsp-ui-doc-position (quote top))
  
  
  (require 'company-lsp)
  (add-to-list (make-local-variable 'company-backends)
               '(company-lsp company-files company-abbrev company-dabbrev
                             company-keywords))

  (setq company-transformers nil
        company-lsp-async t
        company-lsp-cache-candidates nil)
  
  (company-quickhelp-mode)

;  (add-hook 'before-save-hook 'gofmt-before-save)

  (define-key go-mode-map [(control f7)] 'projman-grep)
  (define-key go-mode-map [f7] 'lsp-ui-peek-find-references)
  (define-key go-mode-map "\C-j" 'xref-find-definitions)
  (define-key go-mode-map "\M-j" 'xref-pop-marker-stack)
  (define-key go-mode-map "\C-hj" 'godoc-at-point)
  (define-key hs-minor-mode-map "\M-h\M-t" 'hs-toggle-hiding)
  (define-key hs-minor-mode-map "\M-h\M-a" 'hs-hide-all)
  (define-key hs-minor-mode-map "\M-h\M-s" 'hs-show-all)

  ;; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))

  )

(add-to-list 'auto-mode-alist (cons "\\.mod\\'" 'fundamental-mode))
(add-to-list 'auto-mode-alist (cons "\\.go\\'" 'go-mode))

(add-hook 'go-mode-hook 'tserg/go-mode-hook)
