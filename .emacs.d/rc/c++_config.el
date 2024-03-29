;; Package-Requires: ((dash "2.13.0"))

;; Packages list needed--------------------------
(setq c-mode-package-list '(;;project management
                            projectile

                            ;;common utils
                            ws-butler smart-tabs-mode

                            ;;code complete
                            company-c-headers ;C

                            dash
                            ))


(use-package cc-mode
  :ensure nil
  :no-require t ;; lazy config read

  :ensure ggtags

  :mode ;;mode associassion
  ("\\.h\\'" . c++-mode)
  ("\\.cpp\\'" . c++-mode)
  ("\\.cxx\\'" . c++-mode)
  ("\\.ixx\\'" . c++-mode) ; c++ module interface files

  :bind ;;HotKeys
  (
   :map c++-mode-map
        ;; ([remap electric-newline-and-maybe-indent] . xref-find-definitions)
        ;; ("\C-xj" . 'xref-find-definitions)
        ("M-j" . xref-pop-marker-stack)

        ([f2] . ff-find-other-file)
        )
  :init
  (autoload 'c-mode "cc-mode") ;;load only when necessary
  (setq-default ff-ignore-include t)

  :config ;; do after download

  ;; install the missing packages
  (dolist (package c-mode-package-list)
    (unless (package-installed-p package)
      (package-install package)))

  (require 'projectile)

  ;; (projectile-update-project-type
  ;;  'c
  ;;  :related-files-fn
  ;;  (list
  ;;   (projectile-related-files-fn-test-with-suffix "scala" "Spec")
  ;;   (projectile-related-files-fn-test-with-suffix "scala" "Test")))

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

  (smart-tabs-insinuate 'c++ 'c 'java)

  (defun tserg/c-mode-common-hook()
    (setq-local indent-tabs-mode t)
    ;; base-style
    (setq c-default-style "linux"
          c-basic-offset 2
          c-argdecl-indent 0
          cua-auto-tabify-rectangles nil
          fill-column 300) ; Needed for long lines support smart-tabs-mode
    (c-set-offset 'substatement-open 0)
    (c-set-offset 'block-close 0)

    (ggtags-mode 1) ; bad performance when using tramp
    (ws-butler-mode 1)
    (whitespace-mode 1)
    (hs-minor-mode 1)
    (yas-minor-mode 1)
    ;; (flyspell-prog-mode 1)
    (toggle-truncate-lines nil)

    (font-lock-mode t)
    (setq font-lock-maximum-decoration t)

    (smart-tabs-mode-enable)

    (eldoc-mode nil)
    (global-eldoc-mode -1)
    (flymake-mode -1)

    (add-to-list (make-local-variable 'company-backends)
                 '(company-c-headers))

    ;; (company-fuzzy-mode nil)
    ;; (add-to-list 'company-fuzzy-full-input-backends 'company-c-headers)

    ;; (setq-local my-project-root (projectile-ensure-project (projectile-project-root)))
    ;; (setq-local company-c-headers-path-user (cons my-project-root '()))
    (setq-local company-c-headers-path-user (cons default-directory '()))

    (company-quickhelp-mode 1)
    )

  (defun project-find-module (dir)
    (when-let ((root (locate-dominating-file dir ".projectile")))
      (cons 'go-module root)))

  (cl-defmethod project-root ((project (head go-module)))
    (cdr project))

  (add-hook 'project-find-functions #'project-find-module)


  (add-hook 'c-mode-common-hook 'tserg/c-mode-common-hook)
  )
