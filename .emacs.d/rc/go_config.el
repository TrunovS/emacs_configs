;; Packages list needed--------------------------
(setq go-package-list '(;;ui complete
                        company go-mode

                        ;;common utils
                        ws-butler smart-tabs-mode

                        ;;code complete
                        ;; company-lsp - deprecated
                        company-quickhelp
                        go-eldoc ;go docs
                        ag ;silver searcher
                        ))

(use-package go-mode
  :ensure t ;; auto install on startup only go-mode

  :ensure lsp-mode
  :ensure lsp-ui

  ;;defered config read on .go open
  :no-require t
  :defer t

  :mode ;;mode associassion
  ("\\.mod\\'" . 'fundamental-mode)
  ("\\.go\\'" . 'go-mode)

  :bind ;;HotKeys
  (
   :map go-mode-map

        ("C-<f7>" . 'projectile-grep)
        ;; ([remap dumb-jump-go] . xref-find-definitions)
        ("\C-j" . 'dumb-jump-go)
        ("\C-xj" . 'xref-find-definitions)
        ("\C-hj" . 'godoc-at-point)
        )

  :config

  ;; install the missing packages
  (dolist (package go-package-list)
    (unless (package-installed-p package)
      (package-install package)))

  (smart-tabs-add-language-support go go-mode-hook
    ((c-indent-line . c-basic-offset)
     (c-indent-region . c-basic-offset)))

  (smart-tabs-insinuate 'go)

  ;; (defun lsp-ui-peek--peek-display (src1 src2)
  ;;   (-let* ((win-width (frame-width))
  ;;           (lsp-ui-peek-list-width (/ (frame-width) 2))
  ;;           (string (-some--> (-zip-fill "" src1 src2)
  ;;                     (--map (lsp-ui-peek--adjust win-width it) it)
  ;;                     (-map-indexed 'lsp-ui-peek--make-line it)
  ;;                     (-concat it (lsp-ui-peek--make-footer))))
  ;;           )
  ;;     (setq lsp-ui-peek--buffer (get-buffer-create " *lsp-peek--buffer*"))
  ;;     (posframe-show lsp-ui-peek--buffer
  ;;                    :string (mapconcat 'identity string "")
  ;;                    :min-width (frame-width)
  ;;                    :poshandler #'posframe-poshandler-frame-center)))

  ;; (defun lsp-ui-peek--peek-destroy ()
  ;;   (when (bufferp lsp-ui-peek--buffer)
  ;;     (posframe-delete lsp-ui-peek--buffer))
  ;;   (setq lsp-ui-peek--buffer nil
  ;;         lsp-ui-peek--last-xref nil)
  ;;   (set-window-start (get-buffer-window) lsp-ui-peek--win-start))

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


    (add-to-list (make-local-variable 'company-backends)
                 '(company-capf company-files ;; company-abbrev company-dabbrev
                                company-keywords))
    ;; (require 'lsp)

    ;; (setq-default lsp-log-io t)
    ;; ;; (setq-default lsp-server-trace "verbose")

    ;; (lsp-register-client
    ;;  (make-lsp-client :new-connection (lsp-tramp-connection (lambda ()

    ;;                                                           ;; (cons "gopls" lsp-gopls-server-args)
    ;;                                                           (cons "gopls"
    ;;                                                                 '("-debug" "-vv" "-rpc.trace" "-logfile" "/tmp/gopls.log"))
    ;;                                                           ))
    ;;                   :major-modes '(go-mode)
    ;;                   :remote? t
    ;;                   :server-id 'gopls-remote))
    ;; ;; (setq inhibit-eol-conversion t)

    ;; (lsp 1)
    ;; (lsp-ui-mode 1)
    ;; ;; ;; (setq lsp-log-io nil)
    ;; ;; ;; (setq lsp-ui-doc-include-signature nil)  ; don't include type signature in the child frame
    ;; (setq lsp-ui-sideline-enable nil)  ; don't show symbol on the right of info
    ;; (eldoc-mode nil)
    ;; (global-eldoc-mode -1)
    ;; (setq lsp-ui-doc-position (quote at-point;; top
    ;;                                  ))

    ;; (advice-add #'lsp-ui-peek--peek-new :override #'lsp-ui-peek--peek-display)
    ;; (advice-add #'lsp-ui-peek--peek-hide :override #'lsp-ui-peek--peek-destroy)


    (company-quickhelp-mode)

    ;;  (add-hook 'before-save-hook 'gofmt-before-save)

    ;; Customize compile command to run go build
    (if (not (string-match "go" compile-command))
        (set (make-local-variable 'compile-command)
             "go build -v && go test -v && go vet"))

    )

  (add-hook 'go-mode-hook 'tserg/go-mode-hook)

  ;; (defun project-find-go-module (dir)
  ;;   (when-let ((root (locate-dominating-file dir "go.mod")))
  ;;     (cons 'go-module root)))

  ;; (cl-defmethod project-root ((project (head go-module)))
  ;;   (cdr project))

  ;; (add-hook 'project-find-functions #'project-find-go-module)

  ;; (require 'company)
  ;; (require 'yasnippet)

  ;; (require 'go-mode)
  ;; (require 'eglot)

  ;; (add-to-list 'eglot-server-programs
  ;;              `(go-mode . ("gopls" "-debug" "-vv" "-logfile" "/tmp/gopls.log")))

  ;; (add-hook 'go-mode-hook 'eglot-ensure)
  )
