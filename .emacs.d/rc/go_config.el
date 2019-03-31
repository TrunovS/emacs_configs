(require 'go-mode)

(defun tserg/go-mode-hook()
  (require 'lsp)
  (require 'lsp-clients)
  (require 'lsp-ui)

  (ws-butler-mode)
  (whitespace-mode)
  ;; stop whitespace being highlighted
  (whitespace-toggle-options '(tabs))
 
  (hs-minor-mode)
  (toggle-truncate-lines nil)
  (setq-local auto-hscroll-mode 'current-line);;emacs version >= 26
  (font-lock-mode t)
  (setq font-lock-maximum-decoration t)
  (setq godoc-at-point-function (quote godoc-gogetdoc))

  (local-set-key [(control return)] 'ac-complete)
  (define-key go-mode-map "\C-j" 'godef-jump)
  (define-key go-mode-map "\M-j" 'pop-tag-mark)
  (define-key go-mode-map "\C-hj" 'godoc-at-point)
  (define-key hs-minor-mode-map "\M-h\M-t" 'hs-toggle-hiding)
  (define-key hs-minor-mode-map "\M-h\M-a" 'hs-hide-all)
  (define-key hs-minor-mode-map "\M-h\M-s" 'hs-show-all)

  ;; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))

  ;; (lsp)
  ;; (lsp-ui-mode)
  ;; (setq lsp-ui-doc-include-signature nil)  ; don't include type signature in the child frame
  ;; (eldoc-mode nil)  
  ;; (global-eldoc-mode -1)
  ;; (setq lsp-ui-doc-position (quote top))
  )

(add-to-list 'auto-mode-alist (cons "\\.mod\\'" 'fundamental-mode))
(add-to-list 'auto-mode-alist (cons "\\.go\\'" 'go-mode))

(add-hook 'go-mode-hook 'tserg/go-mode-hook)
