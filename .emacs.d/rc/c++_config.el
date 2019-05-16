;; Package-Requires: ((dash "2.13.0"))

;; For switch between header and source -----------------
 ;; Switch fromm *.<impl> to *.<head> and vice versa
(defun switch-cc-to-h ()
  (interactive)
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
  (setq flist (projman-project-files))

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

;; (when (load "flymake" t)
;;  (defun flymake-pyflakes-init ()
;;     ; Make sure it's not a remote buffer or flymake would not work
;;     (when (not (subsetp (list (current-buffer)) (tramp-list-remote-buffers)))
;;      (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                         'flymake-create-temp-inplace))
;;             (local-file (file-relative-name
;;                          temp-file
;;                          (file-name-directory buffer-file-name))))
;;        (list "pyflakes" (list local-file)))))
;;  (add-to-list 'flymake-allowed-file-name-masks
;;               '("\\.py\\'" flymake-pyflakes-init)))

;; Reuse Compilation ----------------------------------------
(push '("\\*compilation\\*" . (nil (reusable-frames . t))) display-buffer-alist)

(defun tserg/c-mode-common-hook()
  ;; base-style
  (setq c-set-style "linux"
        c-basic-offset 4
        c-indent-level 4
        c-argdecl-indent 0
        c-tab-always-indent t)
  (c-set-offset 'substatement-open 0)
  (ws-butler-mode)
  (whitespace-mode)
  (hs-minor-mode)
  (flyspell-prog-mode)
  (toggle-truncate-lines nil)
  (setq-local auto-hscroll-mode 'current-line);;emacs version >= 26

  (font-lock-mode t)
  (setq font-lock-maximum-decoration t)

  (define-key c-mode-base-map [f2] 'my-switch-h-cpp-in-projman-project)
  (define-key c-mode-base-map [f5] 'myrefact)
  (define-key hs-minor-mode-map "\M-h\M-t" 'hs-toggle-hiding)
  (define-key hs-minor-mode-map "\M-h\M-a" 'hs-hide-all)
  (define-key hs-minor-mode-map "\M-h\M-s" 'hs-show-all)

  (require 'cquery)
  ;; (setq cquery-project-roots 'projman-project-root)
  (setq cquery-executable "/home/sergey/cquery/build/release/bin/cquery")
  (lsp)
  (lsp-ui-mode)
  (setq lsp-ui-doc-include-signature nil)  ; don't include type signature in the child frame
  (setq lsp-ui-sideline-enable nil)  ; don't show symbol on the right of info
  (eldoc-mode nil)  
  (global-eldoc-mode -1)
  (setq lsp-ui-doc-position (quote top))
  
  
  (require 'company-lsp)
  (push 'company-lsp company-backends)
  (company-quickhelp-mode)
  (add-to-list 'company-backends 'company-c-headers)
;  (local-set-key [(control return)] 'company-complete)

  ;; (lsp-ui-doc-mode -1)

  ;; (define-key c-mode-base-map [(control return)] 'company-complete)
  (define-key c-mode-base-map [(control f7)] 'projman-grep)
  (define-key c-mode-base-map "\C-j" 'xref-find-definitions)
  (define-key c-mode-base-map "\M-j" 'xref-pop-marker-stack)
  (define-key c-mode-base-map [f7] 'lsp-ui-peek-find-references)
  )

(add-hook 'c-mode-common-hook 'tserg/c-mode-common-hook)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cxx\\'" . c++-mode))
