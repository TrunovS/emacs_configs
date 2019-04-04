(defun tserg/go-mode-hook()
  (with-eval-after-load 'go-mode
   (require 'go-autocomplete))

  (setq-local tab-width 4)
  (ws-butler-mode)
  (whitespace-mode)

  (hs-minor-mode)
  (toggle-truncate-lines nil)
  (setq-local auto-hscroll-mode 'current-line);;emacs version >= 26
  (font-lock-mode t)
  (setq font-lock-maximum-decoration t)
  (setq godoc-at-point-function (quote godoc-gogetdoc))

  (add-hook 'before-save-hook 'gofmt-before-save)
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

  )

(add-to-list 'auto-mode-alist (cons "\\.mod\\'" 'fundamental-mode))
(add-to-list 'auto-mode-alist (cons "\\.go\\'" 'go-mode))

(add-hook 'go-mode-hook 'tserg/go-mode-hook)
