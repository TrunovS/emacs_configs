;; Packages list needed--------------------------
(setq package-list '(quelpa-use-package
                     ;;theme specific
                     auto-dim-other-buffers smart-mode-line nova-theme

                     ;;project management
                     projectile ag counsel-projectile ggtags

                     ;;ui complete
                     ivy ivy-posframe counsel
                     company-posframe company-fuzzy
                     company-quickhelp

                     ;;common utils
                     auto-highlight-symbol
                     uuidgen exec-path-from-shell google-this ws-butler iedit fuzzy flx autopair
                     yasnippet yasnippet-snippets
                     dumb-jump xterm-color interleave dired-narrow smex wgrep

                     ;;VCS management
                     ahg magit

                     ;;custom modes
                     dockerfile-mode docker-compose-mode undo-tree yaml-mode
                     ))

; install the missing packages
(dolist (new_package package-list)
  (unless (package-installed-p new_package)
    (message "Installing new package %s" new_package)
    (package-install new_package)))

(eval-when-compile
  (require 'use-package)
  (require 'quelpa-use-package)
  )

(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))

(use-package use-package-ensure-system-package
  :ensure t)

;;date time zone----------------
(setq-default datetime-timezone 'Europe/Moscow)

;;tramp -----------------------
(use-package tramp
  :ensure nil
  :config
  ;; (setq-default auto-revert-remote-files t)
  ;; auto-revert-use-notify nil?
  (setq-default enable-remote-dir-locals t)
  (setq-default vc-handled-backends '(Hg Git))
  (setq-default remote-file-name-inhibit-cache nil)
  (setq-default tramp-completion-reread-directory-timeout nil)

  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  )

;; undo tree mode --------------
(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode 1)
  (add-to-list 'display-buffer-alist
             `("*undo-tree*"
               (display-buffer-reuse-window
                display-buffer-in-side-window)
               (reusable-frames . visible)
               (side            . left)
               (window-width   . 0.1)))
  )

;; Theme--------------------
(use-package nova-theme
  :ensure t

  :init
  (setq initial-major-mode 'fundamental-mode)
  (setq frame-inhibit-implied-resize t)

  (cond ((eq system-type 'darwin) ;mac os
         (add-to-list 'default-frame-alist '(font . "Hack-12"))
         (menu-bar-mode 1)

         ;; mac os russian mac input setup
         (use-package russian-mac
           :quelpa ((russian-mac :fetcher github :repo "juev/russian-mac") :upgrade t)
           :config

           (setq-default default-input-method "russian-mac"))
         )
        (t (add-to-list 'default-frame-alist '(font . "Hack-9"))
           (menu-bar-mode -1))
        )

  :config
  (load-theme 'nova t)
  (global-hl-line-mode t)
  (show-paren-mode 1)
  (autopair-global-mode)
  (setq-default frame-resize-pixelwise t)

  (global-auto-revert-mode 1)   ;; auto refresh when file changes

  (setq-default inhibit-compacting-font-caches t)
  (setq-default indent-tabs-mode nil)

  (setq show-paren-style 'expression
        column-number-mode t
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

  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (fset 'yes-or-no-p 'y-or-n-p)

  ;; fixing some perfomance issues with long lines of base64 text
  (setq-default auto-window-vscroll nil)
  (setq-default line-move-visual nil)
  (setq-default bidi-paragraph-direction 'left-to-right)
  (setq-default bidi-inhibit-bpa nil)

  (set-face-background 'default "#353535")
  (set-face-attribute 'cursor  nil :background "white")
  (set-face-attribute 'region nil :background "#399948f45199")
  (set-face-attribute 'hl-line nil :background "dim gray")
  (set-face-attribute 'highlight nil
                      :background (color-darken-name (face-background 'default) 10))

  ;; (setq frame-resize-pixelwise t)
  ;; (toggle-frame-maximized)
  )

(use-package auto-highlight-symbol
  :ensure t

  :init
  (setq auto-highlight-symbol-mode-map (make-sparse-keymap))

  :config

  (global-auto-highlight-symbol-mode 1)
  (global-auto-highlight-symbol-mode 0)
  ;; (assq-delete-all 'auto-highlight-symbol-mode-map minor-mode-map-alist)
  )

(use-package auto-dim-other-buffers
  :ensure t
  :config
  (auto-dim-other-buffers-mode t)
  (set-face-attribute 'auto-dim-other-buffers-face nil
                      :foreground (color-darken-name (face-foreground 'default) 5)
                      :background (color-darken-name (face-background 'default) 2))
  )

(use-package diff-mode
  :ensure nil
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

  (defun tserg/ediff-before-setup ()
    (select-frame (make-frame)))
 (add-hook 'ediff-before-setup-hook 'tserg/ediff-before-setup)
  )

(when (require 'so-long nil :noerror)
   (global-so-long-mode 1))

;; Load sessions--------------
(setq desktop-restore-eager 7
      desktop-load-locked-desktop t
      special-display-buffer-names nil;'("*grep*" "*compilation*" "*clang error")
      special-display-regexps nil
      )

;; mode-line-----------------
(use-package simple-modeline
  :ensure t
  :init
  (setq simple-modeline-segments
   '((simple-modeline-segment-modified simple-modeline-segment-buffer-name simple-modeline-segment-position)
     (simple-modeline-segment-input-method simple-modeline-segment-eol simple-modeline-segment-encoding simple-modeline-segment-vc simple-modeline-segment-misc-info simple-modeline-segment-process simple-modeline-segment-major-mode)))
  :hook (after-init . simple-modeline-mode)
  :config
  )

;; Set Path----------------------------------
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  )

;; pop up buffers management-----------------
(use-package popper
  :ensure t
  :bind (("C-'"   . popper-toggle-latest)
         ("M-'"   . popper-cycle)
         ("C-M-'" . popper-toggle-type))
  :init

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

  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "^magit.*$"
          "^\\*[A-Za-z ]*search.*\\*$"
          "^\\*ivy.*$"
          "^\\*.*\\*$"
          help-mode
          compilation-mode))
  (popper-mode +1)
  (setq popper-display-control nil)
  )

;; frequency completition candidates sorting ---------
(use-package prescient
  :ensure t
  :config
  (prescient-persist-mode 1)
  )

;; IVY competition --------------------------
(use-package ivy
  :ensure t
  :ensure ivy-posframe
  :ensure ivy-xref
  :ensure counsel
  :ensure counsel-projectile
  :ensure ivy-prescient

  :functions (grep-like-transformer tserg/fontify-with-mode tserg/fontify-using-faces)

  :bind
  (
   :map global-map
        ("M-x" . counsel-M-x)
        ("\C-cf" . projectile-find-file)
   :map ivy-minibuffer-map
        ("C-c C-n" . ivy-restrict-to-matches)
        ("C-M-j" . ivy-immediate-done)  ;select what i typed
        )
  :init
  (ivy-mode 1)
  (ivy-posframe-mode 1)
  (counsel-mode 1)
  (ivy-prescient-mode 1)

  :config

  ;; (set-face-attribute 'ivy-posframe-border nil
  ;;                     :foreground nil :background "black")
  (set-face-attribute 'ivy-posframe nil
                       :foreground nil :background (color-darken-name (face-background 'default) 7))

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

  (ivy-set-actions
   'projectile-find-file
   '(("p" projectile-switch-project "switch project")
     ))

  (setq-default ivy-posframe-display-functions-alist
                '(
                  (t . ivy-posframe-display-at-frame-center)))


  ;; (ivy-set-display-transformer 'counsel-ag 'counsel-git-grep-transformer)
  )

;; Project manager --------------------------
(use-package projectile
  :ensure t
  :ensure ag

  :init
  (projectile-mode +1)

  :config

  (setq-default projectile-hg-command "hg files -0 .")
  (setq-default projectile-indexing-method 'alien);;hybrid
  (setq-default projectile-completion-system 'ivy)
  (setq-default projectile-mode-line-function
                '(lambda ()
                   (format " Proj[%s]" (projectile-project-name))))
  (setq-default ag-group-matches nil)
  (setq-default ag-ignore-list `("*orig"))
  (setq-default projectile-globally-ignored-files '("*orig" "*.log" "*.o$" "*.a$"))
  (setq-default projectile-globally-ignored-file-suffixes nil)
  )

;; Dumb jump ---------------------------------
(use-package dumb-jump
  :ensure t
  :defer t

  :bind ;;HotKeys
  (
   :map global-map
        ([remap electric-newline-and-maybe-indent] . xref-find-definitions)
        ("C-j" . dumb-jump-go)
        ("C-x j" . xref-find-definitions)
        ("M-j" . xref-pop-marker-stack)
   )

  :functions (grep-like-transformer tserg/fontify-with-mode tserg/fontify-using-faces)

  :init

  (require 'xref)
  (setq xref-backend-functions (delq 'etags--xref-backend xref-backend-functions))
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

  :config

  (setq-default dumb-jump-max-find-time 10)
  ;; (setq-default dumb-jump-prefer-searcher 'ag)
  (setq-default dumb-jump-force-searcher 'ag)
  (setq-default dumb-jump-selector 'ivy)

  (require 'counsel)
  (require 'projectile)
  (ivy-set-display-transformer 'dumb-jump-ivy-jump-to-selected  'grep-like-transformer)
  )

;; magit --------------------------------------------
(use-package magit
  :ensure t

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
  (set-face-attribute 'magit-diff-context-highlight nil
                      :foreground nil :background nil)
  (set-face-attribute 'magit-diff-context nil
                      :foreground nil :background nil)
  ;; (set-face-attribute 'magit-diff-added-highlight nil
  ;;                     :foreground "red" :background "nil")
  )

(use-package ggtags
  :ensure t
  )

;; Company complete --------------------------------------------
(use-package company
  :ensure t
  :ensure company-posframe
  :ensure company-fuzzy
  :ensure flx
  ;; :ensure company-flx

  :bind*
  ("M-." . company-complete)

  :init
  (add-hook 'after-init-hook 'global-company-mode)

  :config
  ;; set default `company-backends'
  (setq company-backends
        '((company-capf
           company-files          ; files & directory
           company-yasnippet ; this one can be blocking and performance slow
           company-dabbrev ; this one can be blocking and performance slow
           company-dabbrev-code ; this one can be blocking and performance slow
           )
          ))

  (company-posframe-mode 1)

  ;; (global-company-fuzzy-mode 0)
  ;; (setq company-fuzzy-sorting-backend 'flx)

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

;; whitespace config --------------------------------------------
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
  (set-face-attribute 'whitespace-tab nil :foreground "dim gray" :background nil)
  (set-face-attribute 'whitespace-trailing nil :foreground "black" :background nil)

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

(use-package yasnippet ;----------------------------------------------
  :ensure t
  :ensure yasnippet-snippets
  :config
  (yas-global-mode 1)
  )

;; Auto Encode buffer -----------------------------------
(use-package unicad
  :ensure nil
  :load-path "lisp"
  )
;; (load-file "~/.emacs.d/unicad.el")

;;Systems customize ---------------------------------
(cond ((eq system-type 'cygwin) ;; Cygwin
       (load "~/.emacs.d/lisp/cygwin-mount.el")
       (load "~/.emacs.d/lisp/windows-path.el")
       (require 'windows-path)
       (windows-path-activate)
       (set-file-name-coding-system 'utf-8)
       (message "Cygwin")
       )
      ((string-equal system-type "darwin") ;; Mac OS X
       (progn
         (setq mac-option-key-is-meta nil)
         (setq mac-command-key-is-meta t)
         (setq mac-command-modifier 'meta)
         (setq mac-option-modifier nil)
         (message "Mac OS X")))
      )

;;Dired-----------------------------------------------------------
(require 'dired)
(setq dired-listing-switches "-lta");;-lt
(setq directory-free-space-program nil)
(setq-default dired-dwim-target 1)
(add-hook 'dired-mode-hook 'auto-revert-mode) ;; auto refresh dired when file changes
(define-key dired-mode-map "N" 'dired-narrow-fuzzy)

;; Service managing -----------------------------------------------
(use-package prodigy
  :ensure t

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
   :stop-signal 'sigkill
   :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "BankAdapter"
    :command "ssh"
    :args '("-t" "work_wsl" "/mnt/c/code/UPG_Main/x64/Debug/UPGBankAdapter.exe --debug | cat -e")
    :ready-message "HandlerRouting was setup"
    :stop-signal 'sigkill
    :kill-process-buffer-on-stop 1)

  (prodigy-define-service
    :name "DocSigner"
    :command "ssh"
    :args '("-t" "work_wsl" "/mnt/c/code/UPG_Main/x64/Debug/UPGDocSigner.exe --debug | cat -e")
    :ready-message "HandlerRouting was setup"
    :stop-signal 'sigkill
    :kill-process-buffer-on-stop t)
  )



;; Mercurial--------------------------------------------------
(use-package ahg
  :ensure t
  :config
  (add-to-list 'display-buffer-alist
               `(,(rx "*hg")
                 (display-buffer-reuse-window
                  display-buffer-in-side-window)
                 (reusable-frames . visible)
                 (side            . right)
                 (window-width   . 0.3)))

  (add-to-list 'display-buffer-alist
               `(,(rx "*aHg")
                 (display-buffer-reuse-window
                  display-buffer-in-side-window)
                 (reusable-frames . visible)
                 (side            . right)
                 (window-width   . 0.3)))
  )

;; shell color customization------------------------------------------
(use-package shell
  :ensure nil

  :config
  (setq comint-output-filter-functions
        (remove 'ansi-color-process-output comint-output-filter-functions))

  (add-hook 'shell-mode-hook
            (lambda () (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t)))
  )

;; You can also use it with eshell (and thus get color output from system ls):
(use-package eshell
  :ensure nil
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
  )

;;Background---------------------------------------------------------
;; (set-face-background 'default "#353535")
;; (set-face-foreground 'default "#efefef")

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
    	(decf n)))))


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

(print (if (projectile-project-p) (projectile-project-root) default-directory))

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
        ;(message "str [%s], Abs path [%s], r_dir [%s]" str abs_path r_dir)
        (setq relative_dir (file-relative-name abs_path r_dir))
        (concat (propertize relative_dir 'face 'link) ":"
                (propertize flinam 'face 'link)
                (tserg/fontify-using-faces (tserg/fontify-with-mode major-mode ftooltip)))
        )
    str)
  )

;TODO: use this with occure to colorize found code lines with .
(defun tserg/get-major-mode-by-filename (name)
  (let* ((remote-id (file-remote-p name))
         (case-insensitive-p (file-name-case-insensitive-p name)))
    ;; Remove backup-suffixes from file name.
    (setq name (file-name-sans-versions name))
    ;; Remove remote file name identification.
    (when (and (stringp remote-id)
               (string-match (regexp-quote remote-id) name))
      (setq name (substring name (match-end 0))))
    (loop
     ;; Find first matching alist entry.
     (setq mode
           (if case-insensitive-p
               ;; Filesystem is case-insensitive.
               (let ((case-fold-search t))
                 (assoc-default name auto-mode-alist
                                'string-match))
             ;; Filesystem is case-sensitive.
             (or
              ;; First match case-sensitively.
              (let ((case-fold-search nil))
                (assoc-default name auto-mode-alist
                               'string-match))
              ;; Fallback to case-insensitive match.
              (and auto-mode-case-fold
                   (let (((custom-autoload symbol load noset)se-fold-search t))
                     (assoc-default name auto-mode-alist
                                    'string-match))))))
     (if (and mode
              (consp mode)
              (cadr mode))
         (setq mode (car mode)
               name (substring name 0 (match-beginning 0)))
       )
     (when mode
       (return mode)))
    )
  )

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
  (if (= 1 (length (window-list)))
      (jump-to-register '_)
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows)
      )))

;; GLOBAL HOTKEYS----------------------------------------------------------------------------
(global-set-key "\C-c\C-g" 'google-this)
(global-set-key "\C-cb" 'switch-to-buffer-other-frame)
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
(global-set-key [f4] 'eshell-new)
(global-set-key [f7] 'counsel-projectile-ag)
(global-set-key [(control f8)] 'compile)
(global-set-key [f8] 'projectile-compile-project)
(global-set-key [f9] 'replace-string)
(global-set-key [f10] 'kmacro-end-and-call-macro)

(global-set-key "\C-xm" nil)
