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

  (setq lfname (car (-filter
                     (lambda (num)
                       (string-match (concat "/" fprefix "." fsuffix) num))
                     flist)))
  (find-file lfname)
  )

;; Auto-comlete C++\C headers -------------------------------------------------
(defun tserg/ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"/usr/lib/gcc/x86_64-linux-gnu/4.8/include")
  (add-to-list 'achead:include-directories '"/usr/include/c++/4.8")
  ;; (add-to-list 'achead:include-directories '"/usr/include/qt4/QtGui")
  ;; (add-to-list 'achead:include-directories '"/usr/include/qt4/QtCore")
  ;; (add-to-list 'achead:include-directories '"/usr/include/qt4/Qt")
  )

;;Semantic---------------------------------------------------------
(require 'cedet)
(require 'semantic)
(require 'semantic/ia)
(require 'semantic/bovine/gcc)

(setq semantic-default-submodes
      '(global-semantic-idle-scheduler-mode
        global-semanticdb-minor-mode
        global-semantic-idle-summary-mode
        ;; global-semantic-idle-completions-mode
        global-semantic-highlight-func-mode
        global-semantic-stickyfunc-mode
        ;; global-semantic-decoration-mode
        global-semantic-mru-bookmark-mode))

(setq semanticdb-default-save-directory "~/.semanticdb/"
      semantic-complete-inline-analyzer-idle-displayor-class 'semantic-displayor-ghost)
(semantic-mode t)

;; Auto-complete-clang --------------------------------------------------
(require 'auto-complete-clang)

(defun tserg/add-clang-flags-to-project()
  (let ((dir (cadr (memq :root projman-current-project))))
    ;;Найдем только не повторяющиеся дирректрии
    (setq command1 
          (concat "find " dir " -type d \\( -path " dir "servicePrograms -o -path " dir "registration \\) -prune -o -iname '*.h' -printf \"%h\n\" | uniq -u")
          )
    ;;теперь повторяющиеся
    (setq command2 
          (concat "find " dir " -type d \\( -path " dir "servicePrograms -o -path " dir "registration \\) -prune -o -iname '*.h' -printf \"%h\n\" | uniq -d")
          )
    (setq ac1 
          (mapcar (lambda (item)(concat "-I" item))
                  (split-string (shell-command-to-string command1))
                  )
          )
    (setq ac2
          (mapcar (lambda (item)(concat "-I" item))
                  (split-string (shell-command-to-string command2))
                  )
          )
    (setq ac-clang-flags (append  
                          ac1
                          ac2 
                          ac-clang-flags
                                   ) 
          )
    )
  )

(defun tserg/add-semantic-flags-to-project()
  (let ((dir (cadr (memq :root projman-current-project))))
    ;;Найдем только не повторяющиеся дирректрии
    (setq command1 
          (concat "find " dir " -type d \\( -path " dir "servicePrograms -o -path " dir "registration \\) -prune -o -iname '*.h' -printf \"%h\n\" | uniq -u")
          )
    ;;теперь повторяющиеся
    (setq command2 
          (concat "find " dir " -type d \\( -path " dir "servicePrograms -o -path " dir "registration \\) -prune -o -iname '*.h' -printf \"%h\n\" | uniq -d")
          )
    (setq ac1 
          (mapcar (lambda (item)(semantic-add-system-include item 'c++-mode))
                  (split-string (shell-command-to-string command1))
                  )
          )
    (setq ac2
          (mapcar (lambda (item)(semantic-add-system-include item 'c++-mode))
                  (split-string (shell-command-to-string command2))
                  )
          )
    )
  )

(defun tserg/set-default-ac-clang-flags()
  (if (member "-I/usr/include/c++/4.9" ac-clang-flags) 0
    (setq ac-clang-flags
          (append   
           (mapcar(lambda (item)(concat "-I" item))
                  (split-string
                   "
 /usr/include/c++/4.9
 /usr/include/x86_64-linux-gnu/c++/4.9
 /usr/include/c++/4.9/backward
 /usr/lib/gcc/x86_64-linux-gnu/4.9/include
 /usr/local/include
 /usr/lib/gcc/x86_64-linux-gnu/4.9/include-fixed
 /usr/include/x86_64-linux-gnu
 /usr/include
 /usr/include/eigen3
 /usr/lib/x86_64-linux-gnu
"
                   ;; /usr/share/qt4/mkspecs/linux-g++ 
                   ;; /usr/include/qt4
                   ;; /usr/include/qt4/Qt
                   ;; /usr/include/qt4/QtCore
                   ;; /usr/include/qt4/QtGui
                   ;; /usr/include/qwt-qt4
                   ))
           ac-clang-flags))
    )
  )

(defun tserg/ac-cc-mode-setup ()
  (setq ac-auto-start nil)
  (setq clang-completion-suppress-error 't)
  (local-set-key [(control return)] 'ac-complete-clang)
  ;; (ac-flyspell-workaround)
  (setq ac-sources (append '(
                             ac-source-clang
                             ac-source-yasnippet
                             ac-source-abbrev
                             ;; ac-source-dictionary
                             ;; ac-source-words-in-same-mode-buffers
                             ;; ac-source-words-in-buffer
                             ;; ac-source-filename
                             ;; ac-source-imenu
                             ;; ac-source-files-in-current-dir
                             ;; ac-source-gtags
                             ;; ac-source-semantic
                             ;; ac-source-semantic-raw
                             ;; ac-source-variables
                             ac-source-template
                             ) ac-sources))
  (tserg/set-default-ac-clang-flags)
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
  (tserg/ac-c-header-init)
  (tserg/ac-cc-mode-setup)

  (font-lock-mode t)
  (setq font-lock-maximum-decoration t)

  (progn
    ;; integer/float/scientific numbers
    (font-lock-add-keywords 'c++-mode
                            '(("\\<[\\-+]*[0-9]*\\.?[0-9]+\\([ulUL]+\\|[eE][\\-+]?[0-9]+\\)?\\>"
                               . font-lock-constant-face)))
    ;; ;; user-types (customize!)
    ;; (font-lock-add-keywords 'c++-mode
    ;;                         '(("\\<[A-Za-z_]+[A-Za-z_0-9]*_\\(t\\|type\\|ptr\\)\\>" . font-lock-type-face)))
    ;; ;; Highlighting C++ member function calls
    ;; (font-lock-add-keywords 'c++-mode
    ;;                         '((concat
    ;;                              "\\<[_a-zA-Z][_a-zA-Z0-9]*\\>"       ; Object identifier
    ;;                              "\\s *"                              ; Optional white space
    ;;                              "\\(?:\\.\\|->\\)"                   ; Member access
    ;;                              "\\s *"                              ; Optional white space
    ;;                              "\\<\\([_a-zA-Z][_a-zA-Z0-9]*\\)\\>" ; Member identifier
    ;;                              "\\s *"                              ; Optional white space
    ;;                              "(")                                 ; Paren for method invocation
    ;;                            . 'font-lock-function-name-face))
    )
  (define-key c-mode-base-map [f2] 'my-switch-h-cpp-in-projman-project)
  (define-key c-mode-base-map [f5] 'myrefact)
  (define-key c-mode-base-map "\C-j" 'semantic-ia-fast-jump)
  (define-key c-mode-base-map "\C-xj" 'semantic-complete-jump)
  (define-key hs-minor-mode-map "\M-h\M-t" 'hs-toggle-hiding)
  (define-key hs-minor-mode-map "\M-h\M-a" 'hs-hide-all)
  (define-key hs-minor-mode-map "\M-h\M-s" 'hs-show-all)
  )

;; (add-hook 'c++-mode-hook 'tserg/ac-c-header-init)
;; (add-hook 'c-mode-common-hook 'tserg/ac-c-header-init)
;; (add-hook 'c-mode-common-hook 'tserg/ac-cc-mode-setup)
(add-hook 'c-mode-common-hook 'tserg/c-mode-common-hook)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cxx\\'" . c++-mode))

(defun my-prepare-for-coding()
  (interactive)
  (tserg/add-semantic-flags-to-project)
  (tserg/add-clang-flags-to-project)
  )

(defun my-set-c11()
  (interactive)
  (setq ac-clang-flags
        (append '("-std=c++11") ac-clang-flags))
  )

(defun my-drop-clang-flags ()
  (interactive)
  (setq ac-clang-flags '())
  )
