;; Packages list needed--------------------------
(setq package-list '(gnu-elpa-keyring-update

                     quelpa-use-package

                     ;;theme specific
                     auto-dim-other-buffers nova-theme

                     ;;project management
                     projectile ag counsel-projectile ggtags

                     ;;ui complete
                     ivy ivy-posframe counsel
                     company-posframe company-fuzzy
                     company-quickhelp

                     ;;common utils
                     uuidgen exec-path-from-shell google-this ws-butler iedit fuzzy flx
                     yasnippet yasnippet-snippets
                     dumb-jump xterm-color ;interleave
                     dired-narrow smex wgrep

                     ;;VCS management
                     ahg magit

                     ;;custom modes
                     dockerfile-mode docker-compose-mode undo-tree yaml-mode
                     ))


;; (defmacro k-time (&rest body)
;;   "Measure and return the time it takes evaluating BODY."
;;   `(let ((time (current-time)))
;;      ,@body
;;      (float-time (time-since time))))

; install the missing packages
(message "package list install takes %.02fsec to load"
         (k-time (dolist (new_package package-list)
                   (unless (package-installed-p new_package)
                     (message "Installing new package %s" new_package)
                     (package-install new_package)))))

(message "quelpa init takes %.02fsec to load"
         (k-time (eval-when-compile
                     (quelpa
                      '(quelpa-use-package
                        :fetcher git
                        :url "https://github.com/quelpa/quelpa-use-package.git"
                        :upgrade nil))

                   (require 'use-package)
                   (require 'quelpa-use-package)
                   )
                 ))

(message "use-package-ensure-system-package takes %.02fsec to load"
         (k-time
          (use-package use-package-ensure-system-package
            :ensure t)
          ))


;;tramp -----------------------
(message "tramp takes %.02fsec to load"
         (k-time (use-package tramp
                   :ensure nil
                   :config
                   ;; (setq-default auto-revert-remote-files t)
                   ;; auto-revert-use-notify nil?
                   (setq-default enable-remote-dir-locals t)
                   (setq-default vc-handled-backends '(Hg Git))
                   (setq-default remote-file-name-inhibit-cache nil)
                   (setq-default tramp-completion-reread-directory-timeout nil)

                   (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
                   ) ))

;; undo tree mode --------------
(message "undo-tree takes %.02fsec to load"
         (k-time (use-package undo-tree
                   :ensure t
                   :defer t

                   :config
                   (global-undo-tree-mode 1)
                   (add-to-list 'display-buffer-alist
                                `("*undo-tree*"
                                  (display-buffer-reuse-window
                                   display-buffer-in-side-window)
                                  (reusable-frames . visible)
                                  (side            . left)
                                  (window-width   . 0.1)))
                   )
                 ))

;; (use-package hexrgb
;;   :quelpa ((hexrgb :fetcher url :url "https://www.emacswiki.org/emacs/download/hexrgb.el") :upgrade t)
;;   :config
;;   (load-file "~/.emacs.d/quelpa/build/hexrgb/hexrgb.el")
;;   )

(message "wsl-path emacs takes %.02fsec to load"
         (k-time (use-package wsl-path
                   :quelpa ((wsl-path :fetcher url :url "https://raw.githubusercontent.com/TrunovS/emacswiki.org/wsl_path_fix_heading/wsl-path.el")
                            :upgrade nil)

                   :config

                   (wsl-path-activate)
                   )))

(message "epithet takes  %.02fsec to load"
         (k-time  (use-package epithet
                    :quelpa ((epithet :fetcher github :repo "oantolin/epithet") :upgrade nil)

                    :config
                    (add-hook 'compilation-start-hook #'epithet-rename-buffer-ignoring-arguments)
                    (add-hook 'compilation-finish-functions #'epithet-rename-buffer-ignoring-arguments)
                    )
                  ))


(message "treesit-parser-manager takes  %.02fsec to load"
         (k-time  (use-package treesit-parser-manager
                    :quelpa ((treesit-parser-manager :fetcher url :url "https://codeberg.org/ckruse/treesit-parser-manager/raw/branch/main/treesit-parser-manager.el") :upgrade nil)

                    :commands (treesit-parser-manager-install-grammars
                               treesit-parser-manager-update-grammars
                               treesit-parser-manager-install-or-update-grammars
                               treesit-parser-manager-remove-grammar)
                    :custom

                    (treesit-parser-manager-grammars
                     '(("https://github.com/tree-sitter/tree-sitter-cpp"
                        ("tree-sitter-cpp"))

                       ("https://github.com/tree-sitter/tree-sitter-json"
                        ("tree-sitter-json"))))
                    :config
                    (setq treesit-extra-load-path (list (expand-file-name "tree-sit-parsers" user-emacs-directory)))

;;                    (use-package ts-movement
;;                     :quelpa ((ts-movement :fetcher github :repo "haritkapadia/ts-movement") :upgrade nil)

;;                     :hook
;;                     ;; (bash-ts-mode-hook . ts-movement-mode)
;;                     (c++-mode-hook . ts-movement-mode)
;;                     (c-ts-mode-hook . ts-movement-mode)
;;                     ;; (cmake-ts-mode-hook . ts-movement-mode)
;;                     ;; (csharp-ts-mode-hook . ts-movement-mode)
;;                     ;; (css-ts-mode-hook . ts-movement-mode)
;;                     ;; (dockerfile-ts-mode-hook . ts-movement-mode)
;;                     ;; (go-mod-ts-mode-hook . ts-movement-mode)
;;                     ;; (go-ts-mode-hook . ts-movement-mode)
;;                     ;; (java-ts-mode-hook . ts-movement-mode)
;;                     ;; (js-ts-mode-hook . ts-movement-mode)
;;                     ;; (json-ts-mode-hook . ts-movement-mode)
;;                     ;; (python-ts-mode-hook . ts-movement-mode)
;;                     ;; (ruby-ts-mode-hook . ts-movement-mode)
;;                     ;; (rust-ts-mode-hook . ts-movement-mode)
;;                     ;; (toml-ts-mode-hook . ts-movement-mode)
;;                     ;; (tsx-ts-mode-hook . ts-movement-mode)
;;                     ;; (typescript-ts-mode-hook . ts-movement-mode)
;;                     ;; (yaml-ts-mode-hook . ts-movement-mode)
;;                     )
                    :hook (emacs-startup . treesit-parser-manager-install-grammars))
                  ))

;; Theme--------------------

;; Good light theme, dark - no so good
;; (use-package graphite-theme
;;   :quelpa ((graphite-theme :fetcher github :repo "codemicmaves/graphite-theme") :upgrade nil)
;;
;;   :config
;;   (load-theme 'graphite-dark t)
;;   )

(message "emacs takes %.02fsec to load"
         (k-time (use-package emacs
                   :ensure nil

                   :ensure nova-theme
                   :ensure rainbow-delimiters

                   :init

                   ;;date time zone----------------
                   (setq-default datetime-timezone 'Europe/Moscow)

                   (setq initial-major-mode 'fundamental-mode)

                   (setq frame-inhibit-implied-resize nil)
                   (setq mode-require-final-newline nil) ;; Don't automatically add newlines at end of files

                   ;;Systems customize ---------------------------------
                   (cond ((eq system-type 'darwin) ;mac os
                          ;; mac os russian mac input setup
                          (use-package russian-mac
                            :quelpa ((russian-mac :fetcher github :repo "juev/russian-mac")
                                     :upgrade nil)

                            :config
                            (setq-default default-input-method "russian-mac"))
                          )
                         )

                   :config

                   (load-theme 'nova t)

                   (rainbow-delimiters-mode-enable)
                   (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

                   (global-hl-line-mode t)
                   (show-paren-mode 1)
                   (electric-pair-mode 1)
                                        ;(autopair-global-mode)
                   (setq-default frame-resize-pixelwise t)

                   (global-auto-revert-mode 1)   ;; auto refresh when file changes

                   (setq-default inhibit-compacting-font-caches t)
                   (setq-default indent-tabs-mode nil)
                   (setq-default tab-width 2) ;A TAB is equivilent to 2 spaces

                   (setq show-paren-style 'expression
                         column-number-mode t
                         line-number-mode t
                         visible-bell t
                         ring-bell-function 'ignore
                         inhibit-startup-message t
                         scroll-step 1
                         toggle-truncate-lines t ;; dont fit long line in buffer
                         truncate-partial-width-windows t
                         make-backup-files nil;; do (not )ot make backup files
                         create-lockfiles nil
                         auto-save-default nil
                         wgrep-auto-save-buffer t ;; auto save occur edits
                         )

                   ;; fixing some perfomance issues with long lines of base64 text
                   ;; (setq-default auto-window-vscroll nil)
                   ;; (setq-default line-move-visual nil)
                   (setq-default bidi-paragraph-direction 'left-to-right)
                   (setq-default bidi-inhibit-bpa t)

                   (set-face-background 'default "#353535")
                   (set-face-attribute 'cursor  nil :background "white")
                   (set-face-attribute 'region nil :background "#399948f45199")

                   (set-face-attribute 'hl-line nil :background (color-lighten-name (face-background 'default) 100))
                   (set-face-attribute 'highlight nil
                                       :background (color-darken-name (face-background 'default) 0))
                   (set-face-attribute 'mode-line nil
                                       :background (color-darken-name (face-background 'default) 65)
                                       ;; :box (:line-width -1 :color "#7FC1CA" :style released-button)
                                       )
                   ;; (set-face-attribute 'header-line nil
                   ;;                     :background (face-background 'mode-line)
                   ;;                     :foreground (face-foreground 'mode-line)
                   ;;                     ;; :box (:line-width -1 :color "#7FC1CA" :style released-button)
                   ;;                     )

                                        ; ~ kill previously set path = magic tilde in ivy
                   (setq file-name-shadow-properties '(invisible t intangible t))
                   (file-name-shadow-mode +1)

                   (setq recentf-keep '(file-remote-p file-readable-p))
                   (setq recentf-max-menu-items 25)
                   (setq recentf-max-saved-items 25)
                   (recentf-mode 1)


                   ;; Load sessions--------------
                   (setq ;; desktop-restore-eager 7
                    ;; desktop-load-locked-desktop t
                    special-display-buffer-names nil;'("*grep*" "*compilation*" "*clang error")
                    special-display-regexps nil
                    )
                   ))
         )


(message "auto-dim-other-buffers emacs takes %.02fsec to load"
         (k-time (use-package auto-dim-other-buffers
                   :ensure t
                   :defer t

                   :config
                   (auto-dim-other-buffers-mode t)
                   (set-face-attribute 'auto-dim-other-buffers-face nil
                                       :foreground (color-darken-name (face-foreground 'default) 10)
                                       :background (color-darken-name (face-background 'default) 25))
                   )
                 )
         )

(message "diff-mode emacs takes %.02fsec to load"
         (k-time (use-package diff-mode
                   :ensure nil

                   :no-require t ;;defered config read
                   :defer t

                   :config

                   (set-face-attribute 'diff-added nil
                                       :foreground "white" :background "DarkGreen")
                   (set-face-attribute 'diff-removed nil
                                       :foreground "white" :background "DarkRed")
                   (set-face-attribute 'diff-changed nil
                                       :foreground "white" :background "dim gray")

                   ;;EDiff---------------------------------------------------------
                   (require 'ediff)
                   (setq ediff-split-window-function 'split-window-horizontally)
                   (setq ediff-window-setup-function 'ediff-setup-windows-plain)

                   (defun q-restore-pre-ediff-winconfig ()
                     (progn
                       (ediff-kill-buffer-carefully "*Ediff Control Panel*")
                       (delete-frame)
                       ))

                   (add-hook 'ediff-quit-hook #'q-restore-pre-ediff-winconfig)

                   (defun tserg/ediff-before-setup ()
                     (select-frame (make-frame)))
                   (add-hook 'ediff-before-setup-hook 'tserg/ediff-before-setup)
                   ))
         )

(when (require 'so-long nil :noerror)
   (global-so-long-mode 1))

(message "rich-minority takes %.02fsec to load"
         (k-time (use-package rich-minority
                   :ensure t
                   :init
                   (setq-default rm-whitelist '("^.*(LSP|lsp).*$"
                                                ))
                   (rich-minority-mode 1)
                   )))


;; Set Path----------------------------------
(message "exec-path-from-shell takes %.02fsec to load"
         (k-time (use-package exec-path-from-shell
                   :ensure t
                   :defer t
                   :config
                   (exec-path-from-shell-initialize)
                   )))

;; pop up buffers management-----------------
(message "popper takes %.02fsec to load"
         (k-time (use-package popper
                   :ensure t
                   :bind (("C-'"   . popper-toggle-latest)
                          ("M-'"   . popper-cycle)
                          ("C-M-'" . popper-toggle-type))
                   :config

                   (add-to-list 'display-buffer-alist
                                `("^\\*[A-Za-z ]*grep.*\\*$"
                                  (display-buffer-reuse-window
                                   display-buffer-in-side-window)
                                  (reusable-frames . visible)
                                  (side            . top)
                                  (window-height   . 0.3)))

                   (add-to-list 'display-buffer-alist
                                `("^\\*[A-Za-z ]*search.*\\*$"
                                  (display-buffer-reuse-window
                                   display-buffer-in-side-window)
                                  (reusable-frames . visible)
                                  (side            . top)
                                  (window-width   . 0.3)))


                   (add-to-list 'display-buffer-alist
                                `("^\\*.*occur.*$"
                                  (display-buffer-reuse-window
                                   display-buffer-in-side-window)
                                  (reusable-frames . visible)
                                  (side            . top)
                                  (slot . 0)
                                  (window-width   . 0.3)))

                   (add-to-list 'display-buffer-alist
                                `("^\\*.*status.*\\*$"
                                  (display-buffer-reuse-window
                                   display-buffer-in-side-window)
                                  (reusable-frames . visible)
                                  (side            . right)
                                  (slot . 0)
                                  (window-height   . 0.3)))


                   (setq popper-reference-buffers
                         '("\\*Messages\\*"
                           "Output\\*$"
                           "^magit.*$"
                           "^\\*[A-Za-z ]*search.*\\*$"
                           "^\\*ivy.*$"
                           "^\\*.*occur.*$"
                           "^\\*.*\\*$"
                           help-mode
                           compilation-mode))

                   (popper-mode +1)
                   (setq popper-display-control nil)

                   ;; (setq popper-display-function #'popper-select-popup-at-bottom)
                   ;; (setq popper-display-function #'display-buffer-in-child-frame)
                   )))
;; frequency completition candidates sorting ---------
(message "prescient takes %.02fsec to load"
         (k-time (use-package prescient
                   :ensure t
                   :config
                   (prescient-persist-mode 1)
                   )
                 ))
;; Completiion --------------------
(message "wgrep takes %.02fsec to load"
         (k-time (use-package wgrep
                   :ensure t
                   :defer t

                   :after ag
                   :bind
                   (
                    :map grep-mode-map
                    ("C-x C-q" . #'wgrep-change-to-wgrep-mode)

                    :map ag-mode-map
                    ("C-x C-q" . #'wgrep-change-to-wgrep-mode)
                    )
                   )
                 ))

(message "mini-frame takes %.02fsec to load"
         (k-time (use-package mini-frame
                   :ensure t

                   :preface
                   (defun my-mini-frame-show-parameters ()
                     `((left . 0.5)
                                        ;(top . ,(/ (frame-pixel-height) 4))
                       (top . 0.25)
                       (width . 0.7)
                       (min-height . 10)
                       ;; (height . 10)
                       ))

                   :init

                   (set-face-attribute 'child-frame-border nil :background "gray50")
                   (setq mini-frame-create-lazy t
                         mini-frame-detach-on-hide nil
                         mini-frame-show-parameters #'my-mini-frame-show-parameters
                         mini-frame-color-shift-step 25
                         child-frame-border-width 1
                         )

                   :config

                   (mini-frame-mode 1)
                   )
                 ))
;; IVY competition --------------------------
(message "ivy takes %.02fsec to load"
         (k-time
          (use-package ivy
            :ensure t

            ;; :ensure ivy-posframe
            :ensure ivy-xref
            :ensure counsel
            :ensure counsel-projectile
            :ensure ivy-prescient

            :functions (grep-like-transformer tserg/fontify-with-mode tserg/fontify-using-faces)

            :bind
            (
             :map global-map
             ("M-x" . counsel-M-x)
             ;; ("C-s" . swiper-isearch)
             ;; ("C-r" . swiper-isearch-backward)
             :map ivy-minibuffer-map
             ("C-c C-n" . ivy-restrict-to-matches)
             ("C-M-j" . ivy-immediate-done)  ;select what i typed
             ("C-w" . ivy-yank-word)  ;select what i typed
             )

            :init

            (ivy-mode 1)
            (counsel-mode 1)
            (ivy-prescient-mode 1)


            :config

            ;; (set-face-attribute 'ivy-posframe-border nil
            ;;                     :foreground nil :background "black")

            ;; (setq-default ivy-dynamic-exhibit-delay-ms 250)
            (setq-default ivy-display-style 'fancy)
            (setq-default ivy-use-virtual-buffers t)
            (setq-default ivy-initial-inputs-alist nil) ; remove initial ^ input.)
            (setq-default ivy-count-format "(%d/%d) ")
            (setq-default ivy-re-builders-alist
                          '((ivy-switch-buffer . ivy--regex-ignore-order)
                            (counsel-ag . ivy--regex-or-literal)
                            (counsel-M-x . ivy--regex-ignore-order)
                            (t . ivy--regex-ignore-order)))

            (ivy-configure 'counsel-yank-pop :height ivy-height)
            (setq-default counsel-yank-pop-truncate-radius 4)
            (setq-default counsel-projectile-find-file-matcher #'ivy--re-filter)
            (setq-default counsel-projectile-find-file-more-chars 3)
            (setq-default counsel-projectile-sort-files nil)
            (setq-default counsel-projectile-ag-initial-input '(ivy-thing-at-point))

                                        ;TODO: uncomment this, to move to xref backend
            ;; ;; xref initialization is different in Emacs 27 - there are two different
            ;; ;; variables which can be set rather than just one
            ;; (if (>= emacs-major-version 27)
            ;;   (setq xref-show-definitions-function #'ivy-xref-show-defs)
            ;;   ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
            ;;   ;; commands other than xref-find-definitions (e.g. project-find-regexp)
            ;;   ;; as well
            ;;   (setq xref-show-xrefs-function #'ivy-xref-show-xrefs)
            ;;   )

            ;; (require 'ivy-posframe)
            ;; (set-face-attribute 'ivy-posframe nil
            ;;                     :foreground nil :background (color-darken-name (face-background 'default) 7))
            ;; (setq-default ivy-posframe-display-functions-alist
            ;;               '(
            ;;                 (t . ivy-posframe-display-at-frame-center)))
            ;; (ivy-posframe-mode 1)

            ;; (ivy-set-display-transformer 'counsel-ag 'counsel-git-grep-transformer)
            )
          ))

;; Project manager --------------------------
(message "projectile takes %.02fsec to load"
         (k-time
          (use-package projectile
            :ensure t
            :ensure ag

            :bind
            (
             :map global-map
             ("\C-cf" . (lambda() (interactive)
                          (cond ((string-equal (projectile-project-root) (expand-file-name default-directory))  (projectile-switch-project))
                                (t (projectile-find-file)))))
             ("\C-cp" . projectile-switch-project)
             )

            :init
            (projectile-mode +1)

            :config

            (setq-default projectile-hg-command "hg files -0 .")
            (setq-default projectile-indexing-method 'alien);;hybrid
            ;; (setq-default projectile-completion-system 'ivy)
            (setq-default projectile-mode-line-function
                          '(lambda ()
                             (format " Proj[%s]" (projectile-project-name))))
            (setq-default ag-group-matches nil)
            (setq-default ag-ignore-list `("*.orig"))
            (setq-default projectile-globally-ignored-files '("*.orig" "*.log" "*.o$" "*.a$"))
            (setq-default projectile-globally-ignored-file-suffixes nil)

            ;; (define-key embark-file-map "p" #'projectile-switch-project)

            ;; (require 'embark)
            ;; (require 'marginalia)

            ;; (setq marginalia-command-categories
            ;;       (append '((projectile-find-file . projectile-file)
            ;;                 (projectile-find-dir . projectile-file)
            ;;                 (projectile-switch-project . file))
            ;;               marginalia-command-categories))
            ;; (add-to-list 'embark-keymap-alist '(projectile-file . projectile-mode-map))
            ;; (add-to-list 'marginalia-prompt-categories '("Switch to:" . projectile-file))

            ;; (ivy-add-actions
            ;;  t
            ;;  '(("p" (lambda(var) (projectile-switch-project)) "switch-project")
            ;;    ))
            )))

;; Dumb jump ---------------------------------
(message "dumb-jump takes %.02fsec to load"
         (k-time
          (use-package dumb-jump
            :ensure t
            :defer t

            :bind ;;HotKeys
            (
             :map global-map
             ([remap electric-newline-and-maybe-indent] . xref-find-definitions)
             ("C-j" .  dumb-jump-go)
             ("C-x j" . xref-find-definitions)
             ("M-j" . xref-pop-marker-stack)
             )

            :functions (grep-like-transformer tserg/fontify-with-mode tserg/fontify-using-faces)

            :init

            (require 'xref)
            (setq xref-backend-functions (delq 'etags--xref-backend xref-backend-functions))
            (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
            (setq xref-show-definitions-function #'xref-show-definitions-buffer)
            ;; (setq xref-show-definitions-function #'xref-show-definitions-completing-read)

            :config

            (setq-default dumb-jump-max-find-time 10)
            (setq-default dumb-jump-force-searcher 'ag)
            (setq-default dumb-jump-selector 'ivy)
            ;; (setq-default dumb-jump-selector 'completing-read)

            (require 'counsel)
            (require 'projectile)
            (ivy-set-display-transformer 'dumb-jump-ivy-jump-to-selected  'grep-like-transformer)
            )))

;; Defer vc actions until explicitly asked --------------------
(message "vc-defer takes %.02fsec to load"
         (k-time
          (use-package vc-defer
            :ensure t
            :config
            (add-to-list 'vc-defer-backends 'Hg)
            (add-to-list 'vc-defer-backends 'Git)
            (vc-defer-mode))))

;; magit --------------------------------------------
(message "magit takes %.02fsec to load"
         (k-time
          (use-package magit
            :ensure t
            :defer t

            :init
            ;; WORKAROUND https://github.com/magit/magit/issues/2395
            (define-derived-mode magit-staging-mode magit-status-mode "Magit staging"
              "Mode for showing staged and unstaged changes."
              :group 'magit-status)
            (defun magit-staging-refresh-buffer ()
              (magit-insert-section (status)
                                    (magit-insert-untracked-files)
                                    (magit-insert-unstaged-changes)
                                    (magit-insert-staged-changes)))
            (defun magit-staging ()
              (interactive)
              (magit-mode-setup #'magit-staging-mode))

            :bind
            (
             :map global-map
             ("\C-cms" . magit-status)
             ("\C-cml" . magit-log-all)
             )

            :config
            (add-to-list 'display-buffer-alist
                         `(".*magit.*"
                           (display-buffer-reuse-window
                            display-buffer-in-side-window)
                           (reusable-frames . visible)
                           (slot . 0)
                           (side            . right)
                           (window-height   . 0.3)))

            (set-face-attribute 'magit-diff-context-highlight nil
                                :foreground nil :background nil)
            (set-face-attribute 'magit-diff-context nil
                                :foreground nil :background nil)
            ;; (set-face-attribute 'magit-diff-added-highlight nil
            ;;                     :foreground "red" :background "nil")
            )))

;; jenkins ----------------------------------------------
(message "jenkins takes %.02fsec to load"
         (k-time
          (use-package jenkins
            :ensure t
            :defer t

            :bind
            (
             :map global-map
             ("\C-cjs" . jenkins)

             :map jenkins-job-view-mode-map
             ("B" . tserg/jenkins-job-call-build-branch)

             :map jenkins-mode-map
             ("B" . tserg/jenkins-job-call-main-build-branch)
             )

            :config

            (defun tserg/jenkins-jobs-view-url ()
              "Jenkins url for get list of jobs in queue and their summaries."
              (format (concat
                       "%s"
                       (if jenkins-viewname "me/my-views/view/%s/" jenkins-viewname "")
                       "api/json?depth=2&tree=name,jobs[name,"
                       "lastSuccessfulBuild[result,timestamp,duration,id],"
                       "lastFailedBuild[result,timestamp,duration,id],"
                       "lastBuild[result,executor[progress]],"
                       "lastCompletedBuild[result]]"
                       )
                      (get-jenkins-url) jenkins-viewname))

            (advice-add 'jenkins-jobs-view-url :override #'tserg/jenkins-jobs-view-url)

            (defun tserg/jenkins-job-call-build-branch ()
              (interactive)
              (let* ((jobname jenkins-local-jobname)
                     (branch_name (read-string (format "[%s] Branch to build: " jobname)))
                     (url-request-extra-headers (jenkins--get-auth-headers))
                     (url-request-method "POST")
                     (config-buffer (get-buffer-create (format "*jenkins-job-param-build-%s*" jobname)))
                     (config-url (format "%sme/my-views/view/%s/job/%s/buildWithParameters?branchName=%s" (get-jenkins-url) jenkins-viewname jobname branch_name))
                     )

                (with-current-buffer config-buffer
                  (erase-buffer)
                  (with-current-buffer (url-retrieve-synchronously config-url)
                    (copy-to-buffer config-buffer (point-min) (point-max))
                    )
                  )
                ))

            (defun tserg/jenkins-job-call-main-build-branch ()
              (interactive)
              (let* ((jobname (tabulated-list-get-id))
                     (branch_name (read-string (format "[%s] Branch to build: " jobname)))
                     (url-request-extra-headers (jenkins--get-auth-headers))
                     (url-request-method "POST")
                     (config-buffer (get-buffer-create (format "*jenkins-job-param-build-%s*" jobname)))
                     (config-url (format "%sme/my-views/view/%s/job/%s/buildWithParameters?branchName=%s" (get-jenkins-url) jenkins-viewname jobname branch_name))
                     )

                (with-current-buffer config-buffer
                  (erase-buffer)
                  (with-current-buffer (url-retrieve-synchronously config-url)
                    (copy-to-buffer config-buffer (point-min) (point-max))
                    )
                  )
                ))

            (defun tserg/jenkins--visit-job-from-job-screen ()
              (let* ((jobname jenkins-local-jobname)
                     (props (text-properties-at (point) (current-buffer)))
                     (jenkins-tag (member 'jenkins-build-number props))
                     (build-number (and jenkins-tag
                                        (cadr jenkins-tag))))
                (browse-url (format "%s/job/%s/%s" (get-jenkins-url) jobname build-number))
                ))
            (advice-add 'jenkins--visit-job-from-job-screen :override #'tserg/jenkins--visit-job-from-job-screen)


            (setq jenkins-api-token "11f4718bf6266d0290c78ae9f07a1a74ba")
            (setq jenkins-url "https://10.42.1.1:8080")
            (setq jenkins-username "sergey_t")
            (setq jenkins-viewname "TrunovS_Develop") ;; if you're not using views skip this line

            (add-to-list 'display-buffer-alist
                         `("^\\*.*jenkins.*\\*$"
                           (display-buffer-reuse-window
                            display-buffer-in-side-window)
                           (reusable-frames . visible)
                           (side            . right)
                           (window-height   . 0.3)))

            )
          ))


;; Company complete --------------------------------------------
(message "company takes %.02fsec to load"
         (k-time
          (use-package company
            :ensure t
            :ensure company-posframe
            :ensure company-fuzzy
            :ensure flx
            ;; :ensure company-flx

            :defer 1

            :bind*
            ("M-." . company-complete)

            :init
            (add-hook 'after-init-hook 'global-company-mode)

            :config
            ;; set default `company-backends'
            (setq company-backends
                  '((
                     company-capf
                     company-files          ; files & directory
                     company-yasnippet ; this one can be blocking and performance slow
                     company-dabbrev ; this one can be blocking and performance slow
                     company-dabbrev-code ; this one can be blocking and performance slow
                     )
                    ))

            (company-posframe-mode 1)

            (global-company-fuzzy-mode t)
            (setq company-fuzzy-sorting-backend 'flx)
            (setq company-eclim-auto-save nil)
            (setq company-require-match nil)
            (setq company-tooltip-align-annotations t)
            (setq company-dabbrev-ignore-case 1)
            (setq company-dabbrev-downcase nil)
            (setq company-dabbrev-char-regexp "\\sw\\|\\s_")
            (setq company-dabbrev-ignore-buffers "log$")

            (setq dabbrev-case-distinction '1)
            (setq dabbrev-case-fold-search 'nil)
            (setq dabbrev-case-replace 'nil)
            )
          ))

;; whitespace config --------------------------------------------
(message "whitespace takes %.02fsec to load"
         (k-time
          (use-package whitespace
            :ensure nil
            :ensure ws-butler
            :ensure popup

            :config
            (setq whitespace-style (quote (face tabs trailing empty tab-mark)));lines
            (setq whitespace-display-mappings
                  '((tab-mark 9 [124 9] [92 9]))) ; 124 is the ascii ID for '\|'
            (setq whitespace-line-column 90)

            (set-face-attribute 'whitespace-line nil :foreground "nil" :overline t)
            (set-face-attribute 'whitespace-tab nil :foreground (color-lighten-name (face-background 'default) 150) :background (face-background 'default))
            (set-face-attribute 'whitespace-trailing nil :foreground "black" :background (face-background 'default))

            (setq ws-butler-keep-whitespace-before-point nil)

            (defun my:force-modes (rule-mode &rest modes)
              "switch on/off several modes depending of state of
    the controlling minor mode"
              (let ((rule-state (if rule-mode 1 -1)
                                ))
                (mapcar (lambda (k) (funcall k rule-state)) modes)
                )
              )

            (defvar my:prev-whitespace-mode nil)
            (make-variable-buffer-local 'my:prev-whitespace-mode)
            (defvar my:prev-whitespace-pushed nil)
            (make-variable-buffer-local 'my:prev-whitespace-pushed)

            (defun my:push-whitespace (&rest skip)
              (if my:prev-whitespace-pushed () (progn
                                                 (setq my:prev-whitespace-mode whitespace-mode)
                                                 (setq my:prev-whitespace-pushed t)
                                                 (my:force-modes nil 'whitespace-mode)
                                                 ))
              )

            (defun my:pop-whitespace (&rest skip)
              (if my:prev-whitespace-pushed (progn
                                              (setq my:prev-whitespace-pushed nil)
                                              (my:force-modes my:prev-whitespace-mode 'whitespace-mode)
                                              ))
              )

            (advice-add 'popup-draw :before #'my:push-whitespace)
            (advice-add 'popup-delete :after #'my:pop-whitespace)
            )
          ))

(message "yasnippet takes %.02fsec to load"
         (k-time
          (use-package yasnippet ;----------------------------------------------
            :ensure t
            :defer t
            :ensure yasnippet-snippets
            :config
            (yas-global-mode 1)
            )
          ))

;;Dired-----------------------------------------------------------
(message "dired takes %.02fsec to load"
         (k-time
          (use-package dired
            :ensure nil
            :defer t

            :config

            (setq dired-listing-switches "-lta");;-lt
            (setq directory-free-space-program nil)
            (setq-default dired-dwim-target 1)
            (setq-default dired-kill-when-opening-new-dired-buffer nil)
            (add-hook 'dired-mode-hook 'auto-revert-mode) ;; auto refresh dired when file changes
            (define-key dired-mode-map "N" 'dired-narrow-fuzzy)

            ;; Use 7z and tar to compress/decompress file if possible.
            (defvar yc/dired-compress-file-suffixes
              (list
               ;; Regexforsuffix-Programm-Args.
               (list (rx "." (or "gz" "Z" "z" "dz" "bz2" "xz" "zip" "rar" "7z")) "7z" "x")
               (list (rx "." (or "tar.gz" "tgz")) "tar" "xzvf")
               (list (rx "." (or "tar.bz2" "tbz")) "tar" "xjvf")
               (list (rx ".tar.xz") "tar" "xJvf"))
              "nil")

            (defun yc/dired-check-process (msg program &rest arguments)
              (let (err-buffer err (dir default-directory))
                (message "%s..." msg )
                (save-excursion
                  ;; Get a clean buffer for error output:
                  (setq err-buffer (get-buffer-create " *dired-check-process output*"))
                  (set-buffer err-buffer)
                  (erase-buffer)
                  (setq default-directory dir   ; caller's default-directory
                        err (not (eq 0 (apply 'process-file program nil t nil
                                              (if (string= "7z" program) "-y" " ") arguments))))
                  (if err
                      (progn
                        (if (listp arguments)
                            (let ((args "") )
                              (mapc (lambda (X)
                                      (setq args (concat args X " ")))
                                    arguments)
                              (setq arguments args)))
                        (dired-log (concat program " " (prin1-to-string arguments) "\n"))
                        (dired-log err-buffer)
                        (or arguments program t))
                    (kill-buffer err-buffer)
                    (message "%s...done" msg)
                    nil))))


            (defun yc/dired-compress-file (file)
              ;; Compress or uncompress FILE.
              ;; Return the name of the compressed or uncompressed file.
              ;; Return nil if no change in files.
              (let ((handler (find-file-name-handler file 'dired-compress-file))
                    suffix newname
                    (suffixes yc/dired-compress-file-suffixes))

                ;; See if any suffix rule matches this file name.
                (while suffixes
                  (let (case-fold-search)
                    (if (string-match (car (car suffixes)) file)
                        (setq suffix (car suffixes) suffixes nil))
                    (setq suffixes (cdr suffixes))))
                ;; If so, compute desired new name.
                (if suffix
                    (setq newname (substring file 0 (match-beginning 0))))
                (cond (handler
                       (funcall handler 'dired-compress-file file))
                      ((file-symlink-p file)
                       nil)
                      ((and suffix (nth 1 suffix))
                       ;; We found an uncompression rule.
                       (if
                           (and (or (not (file-exists-p newname))
                                    (y-or-n-p
                                     (format "File %s already exists.  Replace it? "
                                             newname)))
                                (not (yc/dired-check-process (concat "Uncompressing " file)
                                                             (nth 1 suffix) (nth 2 suffix) file)))
                           newname))
                      (t
            ;;; We don't recognize the file as compressed, so compress it.
            ;;; Try gzip; if we don't have that, use compress.
                       (condition-case nil
                           (let ((out-name (concat file ".7z")))
                             (and (or (not (file-exists-p out-name))
                                      (y-or-n-p
                                       (format "File %s already exists.  Really compress? "
                                               out-name)))
                                  (not (yc/dired-check-process (concat "Compressing " file)
                                                               "7z" "a" out-name file))
                                  ;; Rename the compressed file to NEWNAME
                                  ;; if it hasn't got that name already.
                                  (if (and newname (not (equal newname out-name)))
                                      (progn
                                        (rename-file out-name newname t)
                                        newname)
                                    out-name))))))))

            (defadvice dired-compress (around yc/dired-compress )
              "If last action was not a yank, run `browse-kill-ring' instead."
              (let* (buffer-read-only
                     (from-file (dired-get-filename))
                     (new-file (yc/dired-compress-file from-file)))
                (if new-file
                    (let ((start (point)))
                      ;; Remove any preexisting entry for the name NEW-FILE.
                      (ignore-errors (dired-remove-entry new-file))
                      (goto-char start)
                      ;; Now replace the current line with an entry for NEW-FILE.
                      (dired-update-file-line new-file) nil)
                  (dired-log (concat "Failed to compress" from-file))
                  from-file))
              )
            (ad-activate 'dired-compress)
            )))



;; Service managing -----------------------------------------------
(message "prodigy takes %.02fsec to load"
         (k-time
          (use-package prodigy
            :ensure t
            :defer t

            :bind
            (
             :map global-map
             ("\C-css" . prodigy)
             )


            :config

            (prodigy-define-service
              :name "ServiceProvider"
              :command "ssh"
              :args '("-t" "work_wsl" "/mnt/c/code/UPGo/UPGServiceProvider/UPGServiceProvider.exe --debug | cat -e")
              :ready-message "Launching SP as a console application"
              :stop-signal 'quit
              :kill-process-buffer-on-stop t)

            (prodigy-define-service
              :name "DocConverter"
              :command "ssh"
              :args '("-t" "work_wsl" "/mnt/c/code/UPGo/DocConverter/DocConverter.exe --debug | cat -e")
              ;; :ready-message "Launching SP as a console application"
              :stop-signal 'sigint
              :kill-process-buffer-on-stop t)

            (prodigy-define-service
              :name "Debug_BankAdapter"
              :command "ssh"
              :args '("-t" "work_wsl" "/mnt/c/code/UPG_Main/x64/Debug/UPGBankAdapter.exe --debug | cat -e")
              :ready-message "HandlerRouting was setup"
              :stop-signal 'quit
              :kill-process-buffer-on-stop 1)

            (prodigy-define-service
              :name "Debug_DocSigner"
              :command "ssh"
              :args '("-t" "work_wsl" "/mnt/c/code/UPG_Main/x64/Debug/UPGDocSigner.exe --debug | cat -e")
              :ready-message "HandlerRouting was setup"
              :stop-signal 'quit
              :kill-process-buffer-on-stop t)

            (prodigy-define-service
              :name "Release_bankadapter"
              :command "ssh"
              :args '("-t" "work_wsl" "/mnt/c/code/upg_main/x64/release/upgbankadapter.exe --debug | cat -e")
              :ready-message "handlerrouting was setup"
              :stop-signal 'sigkill
              :kill-process-buffer-on-stop 1)

            (prodigy-define-service
              :name "Release_docsigner"
              :command "ssh"
              :args '("-t" "work_wsl" "/mnt/c/code/upg_main/x64/release/upgdocsigner.exe --debug | cat -e")
              :ready-message "handlerrouting was setup"
              :stop-signal 'quit
              :kill-process-buffer-on-stop t)

            (add-to-list 'display-buffer-alist
                         `("^\\*.*prodigy.*\\*$"
                           (display-buffer-reuse-window
                            display-buffer-in-side-window)
                           (reusable-frames . visible)
                           (slot . 1)
                           (side            . right)
                           (window-height   . 0.3)))

            )))

;; Mercurial--------------------------------------------------
(message "ahg takes %.02fsec to load"
         (k-time
          (use-package ahg
            :ensure t
            :defer 1

            :bind*
            (
             :map ahg-status-mode-map
             (("P" . (lambda() (interactive) (ahg-do-command "push --new-branch")))
              ("C-b" . (lambda() (interactive) (ahg-do-command "commit -m \"close branch\" --close-branch")))
              ([remap ahg-status-dired-find] . (lambda() (interactive) (ahg-do-command "pull")))
              )
             )

            :config
            (add-to-list 'display-buffer-alist
                         `(,(rx "*hg")
                           (display-buffer-reuse-window
                            display-buffer-in-side-window)
                           (reusable-frames . visible)
                           (slot . 0)
                           (side            . right)
                           (window-width   . 0.3)))

            (add-to-list 'display-buffer-alist
                         `(,(rx "*aHg")
                           (display-buffer-reuse-window
                            display-buffer-in-side-window)
                           (reusable-frames . visible)
                           (slot . 0)
                           (side            . right)
                           (window-width   . 0.3)))

            )))

;; shell color customization------------------------------------------
(message "shell takes %.02fsec to load"
         (k-time
          (use-package shell
            :ensure nil

            :defer t

            :config
            (setq comint-output-filter-functions
                  (remove 'ansi-color-process-output comint-output-filter-functions))

            (add-hook 'shell-mode-hook
                      (lambda () (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t)))
            )
          ))

;; You can also use it with eshell (and thus get color output from system ls):
(message "eshell takes %.02fsec to load"
         (k-time
          (use-package eshell
            :ensure nil
            :defer t
            :config
            (add-hook 'eshell-before-prompt-hook
                      (lambda ()
                        (setq xterm-color-preserve-properties t)))
            ;; (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
            ;; (setq eshell-output-filter-functions (remove 'eshell-handle-ansi-color eshell-output-filter-functions))

            (defun eshell-new()
              "Open a new instance of eshell."
              (interactive)
              (eshell 'N))
            )))

(message "multi-vterm takes %.02fsec to load"
         (k-time
          (use-package multi-vterm
            :ensure t
            :defer t


            :bind*
            (
             :map vterm-mode-map
                  ([remap vterm-send-M-c] . clipboard-kill-ring-save)
                  )
            )

          :config
          (set-face-attribute 'vterm-color-black nil
                              :foreground (color-lighten-name (face-background 'default) 200)
                              :background (color-lighten-name (face-background 'default) 200)
                              )
          ))



(message "fancy-narrow takes %.02fsec to load"
         (k-time
          (use-package fancy-narrow
            :ensure t
            :defer t


            :bind
            (
             :map global-map
                  ("\C-cnn" . fancy-narrow-to-defun)
                  ("\C-cnr" . fancy-widen)
                  )
            )
          ))

(message "utils funcs takes %.02fsec to load"
         (k-time
          (with-eval-after-load
              (progn
                (defun duplicate-current-line (&optional n)
                  "duplicate current line, make more than 1 copy given a numeric argument"
                  (interactive "p")
                  (save-excursion
                    (let ((nb (or n 1))
                          (current-line (thing-at-point 'line)))
                      ;; when on last line, insert a newline first
                      (when (or (= 1 (forward-line 1)) (eq (point) (point-max)))
                        (insert "\n"))

                      ;; now insert as many time as requested
                      (while (> n 0)
                        (insert current-line)
                        (cl-decf n)))))

                (defun my-copy-line ()
                  (interactive)
                  (save-excursion
                    (let ((current-line (thing-at-point 'line)))
                      (when (or (= 1 (forward-line 1)) (eq (point) (point-max)))
                        (insert "\n"))
                      (insert current-line)
                      )
                    )
                  )

                (defun my-kill-line ()
                  (interactive)
                  (delete-region (line-beginning-position) (line-end-position))
                  (delete-blank-lines)
                  )

                (defun mywithcp1251()
                  (interactive)
                  (revert-buffer-with-coding-system 'cp1251)
                  )

                (defun mywithutf8()
                  (interactive)
                  (revert-buffer-with-coding-system 'utf-8)
                  )

                (defun goto-match-paren (arg)
                  "Go to the matching parenthesis if on parenthesis. Else go to the
   opening parenthesis one level up."
                  (interactive "p")
                  (cond ((looking-at "\\s\(") (forward-list 1))
                        (t
                         (backward-char 1)
                         (cond ((looking-at "\\s\)")
                                (forward-char 1) (backward-list 1))
                               (t
                                (while (not (looking-at "\\s("))
                                  (backward-char 1)
                                  (cond ((looking-at "\\s\)")
                                         (message "->> )")
                                         (forward-char 1)
                                         (backward-list 1)
                                         (backward-char 1)))
                                  ))))))

                (defadvice ido-find-file (after find-file-sudo activate)
                  "Find file as root if necessary."
                  (unless (and buffer-file-name
                               (file-writable-p buffer-file-name))
                    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))


                (setq revert-without-query (quote (".*.pdf")))

                ;; base64 and utf8 functions -----------------------------
                (defun tserg/base64-encode ()
                  (interactive)
                  (encode-coding-region (region-beginning) (region-end) 'binary)
                  (base64-encode-region (region-beginning) (region-end) 1)
                  )

                (defun tserg/base64-decode ()
                  (interactive)
                  (base64-decode-region (region-beginning) (region-end))
                  (decode-coding-region (region-beginning) (region-end) 'utf-8)
                  )

                (defun base64-to-base64url (str)
                  (setq str (replace-regexp-in-string "=+$" "" str))
                  (setq str (replace-regexp-in-string "+" "-" str))
                  (setq str (replace-regexp-in-string "/" "_" str)))

                (defun base64url-to-base64 (str)
                  (setq str (replace-regexp-in-string "-" "+" str))
                  (setq str (replace-regexp-in-string "_" "/" str))
                  (let ((mod (% (length str) 4)))
                    (cond
                     ((= mod 1) (concat str "==="))
                     ((= mod 2) (concat str "=="))
                     ((= mod 3) (concat str "="))
                     (t str))))

                (defun base64url-encode-string (str)
                  (base64-to-base64url (base64-encode-string str t)))

                (defun base64url-decode-string (str)
                  (base64-decode-string (base64url-to-base64 str)))

                (defun base64url-decode-region (beg end)
                  (interactive "r")
                  (save-excursion
                    (let ((new-text (base64url-decode-string (buffer-substring-no-properties beg end))))
                      (kill-region beg end)
                      (insert new-text))))

                (defun base64url-encode-region (beg end)
                  (interactive "r")
                  (save-excursion
                    (let ((new-text (base64url-encode-string (buffer-substring-no-properties beg end))))
                      (kill-region beg end)
                      (insert new-text))))

                (defun tserg/base64url-encode ()
                  (interactive)
                  (encode-coding-region (region-beginning) (region-end) 'binary)
                  (base64url-encode-region (region-beginning) (region-end))
                  )

                (defun tserg/base64url-decode ()
                  (interactive)
                  (base64url-decode-region (region-beginning) (region-end))
                  (decode-coding-region (region-beginning) (region-end) 'utf-8)
                  )

                (defun html-decode-region (beg end)
                  (interactive "r")
                  (save-excursion
                    (let ((new-text (xml-substitute-special (buffer-substring-no-properties beg end))))
                      (kill-region beg end)
                      (insert new-text)))
                  )

                (defun tserg/html-decode-region ()
                  (interactive)
                  (html-decode-region (region-beginning) (region-end))
                  )


                (defun tserg/fontify-with-mode (mode text)
                  (with-temp-buffer
                    (erase-buffer)
                    (insert text)
                    (delay-mode-hooks (funcall mode))
                    (font-lock-default-function (funcall mode))
                    (font-lock-default-fontify-region (point-min)
                                                      (point-max)
                                                      nil)
                    (buffer-string)))

                ;; needed for font locked buffers
                (defun tserg/fontify-using-faces (text)
                  (let ((pos 0))
                    (while (setq next (next-single-property-change pos 'face text))
                      (put-text-property pos next 'font-lock-face (get-text-property pos 'face text) text)
                      (setq pos next))
                    (add-text-properties 0  (length text) '(fontified t) text)
                    text))

                                        ;TODO: Handle path more accurate
                (defun grep-like-transformer (str)
                  "Highlight file and line number in STR."
                  (if (string-match "\\`\\([^:]+\\):\\([^:]+\\):" str)
                      (let* (
                             (abs_path (substring str (match-beginning 1) (match-end 1)))
                             (flinam (substring str (match-beginning 2) (match-end 2)))
                             (ftooltip (substring str (match-end 2) nil))
                             (root_dir (if (projectile-project-p) (projectile-project-root) default-directory))
                             (r_dir (car (last (split-string root_dir ":"))))
                             )
                        (setq relative_dir (file-relative-name abs_path r_dir))
                                        ;        (message "str [%s], Abs path [%s], r_dir [%s], relative_dir [%s], root_dir [%s]" str abs_path r_dir relative_dir root_dir)
                        (concat (propertize relative_dir 'face 'link) ":"
                                (propertize flinam 'face 'link)
                                (tserg/fontify-using-faces (tserg/fontify-with-mode major-mode ftooltip)))
                        )
                    str)
                  )

                                        ;TODO: use this with occure to colorize found code lines with .
                (defun tserg/get-major-mode-by-filename (file)
                  "Explain in which mode FILE gets visited according to `auto-mode-alist'.
With prefix arg, prompt the user for FILE; else, use function `buffer-file-name'."
                  (interactive
                   (list
                    (if current-prefix-arg
                        (read-file-name "Explain the automatic mode of (possibly non-existing) file: " )
                      (buffer-file-name))))

                  (if (equal "" file)
                      (error "I need some file name to work with"))

                  (let* ((file (expand-file-name file))
                         (index 0)
                         assoc)
                    (setq assoc
                          (catch 'match
                            (while (setq assoc (nth index auto-mode-alist))
                              (if (string-match (car assoc) file)
                                  (throw 'match assoc)
                                (setq index (1+ index))))
                            (setq assoc nil)))

                    (if assoc (cdr assoc))
                    ))

                ;; xml pretty print----------------------------------------
                (defun xml-pretty-print (beg end &optional arg)
                  "Reformat the region between BEG and END.
    With optional ARG, also auto-fill."
                  (interactive "*r\nP")
                  (let ((fill (or (bound-and-true-p auto-fill-function) -1)))
                    (sgml-mode)
                    (when arg (auto-fill-mode))
                    (sgml-pretty-print beg end)
                    (nxml-mode)
                    (auto-fill-mode fill)))


                (defun tserg/revert-all-buffers ()
                  "Refresh all open buffers from their respective files."
                  (interactive)
                  (let* ((list (buffer-list))
                         (buffer (car list)))
                    (while buffer
                      (let ((filename (buffer-file-name buffer)))
                        ;; Revert only buffers containing files, which are not modified;
                        ;; do not try to revert non-file buffers like *Messages*.
                        (when filename
                          (if (file-exists-p filename)
                              ;; If the file exists, revert the buffer.
                              (with-demoted-errors "Error: %S"
                                (with-current-buffer buffer
                                  (revert-buffer :ignore-auto :noconfirm)))
                            ;; If the file doesn't exist, kill the buffer.
                            (let (kill-buffer-query-functions) ; No query done when killing buffer
                              (kill-buffer buffer)
                              (message "Killed non-existing file buffer: %s" buffer))))
                        (setq buffer (pop list)))))
                  (message "Finished reverting non-file buffers."))

                (defun tserg/toggle-maximize-buffer () "Maximize buffer"
                       (interactive)
                       (let ((val (get-register '_)))
                         (if (null val)
                             (progn
                               (window-configuration-to-register '_)
                               (maximize-window)
                               )
                           (progn
                             (jump-to-register '_)
                             (set-register '_ nil)
                             )
                           )))

                ;; GLOBAL HOTKEYS----------------------------------------------------------------------------
                (global-set-key "\C-c\C-g" 'google-this)
                (global-set-key "\M-n" 'forward-paragraph)
                (global-set-key "\M-p" 'backward-paragraph)
                (global-set-key "\C-xl" 'my-copy-line)
                (global-set-key "\C-xd" 'my-kill-line)
                (global-set-key "\C-x\C-d" 'dired)
                (global-set-key "\C-xu" 'undo-tree-undo)
                (global-set-key "\C-xcr" 'revert-buffer)
                (global-set-key "\C-xcc" 'mywithcp1251)
                (global-set-key "\C-xcu" 'mywithutf8)
                (global-set-key "\C-xp" 'goto-match-paren)
                                        ;(global-set-key "\C-j" 'dumb-jump-go)
                (global-set-key "\C-xa" 'align)
                (global-set-key "\M-q" 'kill-buffer-and-window)
                (global-set-key "\M-c" 'clipboard-kill-ring-save)
                (global-set-key "\M-d" 'delete-region)
                (global-set-key "\C-xg" 'universal-coding-system-argument)
                (global-set-key "\M-/" 'comment-or-uncomment-region)
                (define-key global-map (kbd "C-c ;") 'iedit-mode)

                (global-set-key "\C-xm" 'tserg/toggle-maximize-buffer)
                (global-set-key [(meta down)] 'shrink-window)
                (global-set-key [(meta up)] 'enlarge-window)
                (global-set-key [(meta right)] 'enlarge-window-horizontally)
                (global-set-key [(meta left)] 'shrink-window-horizontally)

                (global-set-key [(shift down)] 'windmove-down)
                (global-set-key [(shift up)] 'windmove-up)
                (global-set-key [(shift right)] 'windmove-right)
                (global-set-key [(shift left)] 'windmove-left)

                (global-set-key [f3] 'projectile-dired)
                (global-set-key [f4] 'multi-vterm)
                (global-set-key [f7] 'counsel-projectile-ag)
                (global-set-key [(control f8)] 'compile)
                (global-set-key [f9] 'replace-string)
                (global-set-key [f10] 'kmacro-end-and-call-macro)

                (global-set-key "\C-@" 'profiler-start)
                (global-set-key "\M-@" 'profiler-stop)

                ;; (global-set-key "\C-xm" nil)
                ))))
