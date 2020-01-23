;; Package-Requires: ((dash "2.13.0"))

;; Packages list needed--------------------------
(setq c-mode-package-list '(;;project management
                            projectile

                            ;;ui complete
                            company

                            ;;common utils
                            ws-butler iedit smart-tabs-mode

                            ;;code complete
                            lsp-mode lsp-ui
                            company-quickhelp
                            company-lsp
                            company-c-headers ;C

                            dash
                            ))

(autoload 'c-mode "cc-mode") ;;load only when necessary
(eval-after-load "cc-mode"
  '(progn
     
     ;; install the missing packages
     (dolist (package c-mode-package-list)
       (unless (package-installed-p package)
         (package-install package)))

     (require 'company-lsp)
     (require 'projectile)
     
     (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
     (add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
     (add-to-list 'auto-mode-alist '("\\.cxx\\'" . c++-mode))

     ;; For switch between header and source -----------------
     ;; Switch fromm *.<impl> to *.<head> and vice versa
     (defun switch-cc-to-h ()
       (when (string-match "^\\(.*\\)\\.\\([^.]*\\)$" buffer-file-name)
         (let ((name (match-string 1 buffer-file-name))
               (suffix (match-string 2 buffer-file-name)))
           (cond ((string-match suffix "c\\|cc\\|C\\|cpp")
                  (cond ((file-exists-p (concat name ".h"))
                         (find-file (concat name ".h"))
                         )
                        ((file-exists-p (concat name ".hh"))
                         (find-file (concat name ".hh"))
                         )
                        ))
                 ((string-match suffix "h\\|hh")
                  (cond ((file-exists-p (concat name ".cc"))
                         (find-file (concat name ".cc"))
                         )
                        ((file-exists-p (concat name ".C"))
                         (find-file (concat name ".C"))
                         )
                        ((file-exists-p (concat name ".cpp"))
                         (find-file (concat name ".cpp"))
                         )
                        ((file-exists-p (concat name ".c"))
                         (find-file (concat name ".c"))
                         )))))))


     (defun my-switch-h-cpp-in-projman-project ()
       (interactive)

       ;;выделяем имя файла
       (setq lfname (car (last (split-string buffer-file-name "/"))))
       (setq fprefix (car (split-string lfname "\\.")))
       (setq fsuffix (car (last (split-string lfname "\\."))))
       (setq fsuffix (if (string= "h" fsuffix) "cpp" "h"))

       ;;Составим список всех файлов проекта
       (setq project-root (projectile-ensure-project (projectile-project-root)))

       ;;Составим список всех файлов проекта
       (setq flist (projectile-project-files project-root))
       (require 'dash)
       (setq lfname (car (-filter
                          (lambda (num)
                            (string-match (concat "/" fprefix "." fsuffix) num))
                          flist)))
       (find-file lfname)
       )

     (defun myrefact()
       (interactive)
       (copy-region-as-kill (line-beginning-position) (line-end-position))
       (my-switch-h-cpp-in-projman-project)
       (beginning-of-buffer)
       (search-forward "public:")
       (newline)
       (yank)
       (search-backward ":")
       (forward-char)
       (backward-kill-word 1)
       (move-end-of-line 1)
       (insert ";")
       (indent-region (line-beginning-position) (line-end-position))
       )

     (defun tserg/c-mode-common-hook()
       (setq-local indent-tabs-mode t)
       ;; base-style
       (setq c-set-style "linux"
             c-basic-offset 2
             c-argdecl-indent 0
             )
       (setq-local tab-width 2) ;A TAB is equivilent to 2 spaces
       (c-set-offset 'substatement-open 0)
       (c-set-offset 'block-close 0)
       (smart-tabs-insinuate 'c++)

       (ws-butler-mode 1)
       (whitespace-mode 1)
       (hs-minor-mode 1)
       (flyspell-prog-mode 1)
       (toggle-truncate-lines nil)
       ;; (setq-local auto-hscroll-mode 'current-line);;emacs version >= 26

       (font-lock-mode t)
       (setq font-lock-maximum-decoration t)

       (lsp 1)
       (lsp-ui-mode 1)
       (setq-local lsp-prefer-flymake 'nil)
       (setq lsp-ui-doc-include-signature nil  ; don't include type signature in the child frame
             lsp-ui-sideline-enable nil)  ; don't show symbol on the right of info
       (eldoc-mode nil)
       (global-eldoc-mode -1)
       (flymake-mode -1)
       (setq-local lsp-ui-doc-position (quote top))

       (add-to-list (make-local-variable 'company-backends)
                    '(company-lsp company-c-headers
                                  company-files company-dabbrev))

       (setq-local my-project-root (projectile-ensure-project (projectile-project-root)))
       (setq-local company-c-headers-path-user (cons my-project-root '()))
       ;; Disable client-side cache because the LSP server does a better job.
       (setq company-transformers nil
             company-lsp-async t
             company-lsp-cache-candidates nil)

       (company-quickhelp-mode 1)
       )

     (add-hook 'c-mode-common-hook 'tserg/c-mode-common-hook)

     ;; Mode HotKeys setup-----------------------
     (define-key c-mode-base-map [f2] 'projectile-find-other-file)
     (define-key c-mode-base-map [f5] 'myrefact)
     (define-key c-mode-base-map [(control f7)] 'projectile-grep)
     (define-key c-mode-base-map "\C-j" 'xref-find-definitions)
     (define-key c-mode-base-map "\M-j" 'xref-pop-marker-stack)
     (define-key c-mode-base-map [f7] 'lsp-ui-peek-find-references)
     )
  )

;; lsp remote ----------------------------
;; (require 'lsp)
;; (lsp-register-client
;;  (make-lsp-client :new-connection (lsp-tramp-connection
;; 				                           "/")
;;                   :major-modes '(c-mode c++-mode)
;;                       :remote? t
;;                       :server-id 'clangd-remote))
