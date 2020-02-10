;; Packages list needed--------------------------
(setq package-list '(use-package
                     ;;theme specific
                     auto-dim-other-buffers smart-mode-line nova-theme

                     ;;project management
                     projectile ag counsel-projectile

                     ;;ui complete
                     ivy ivy-posframe counsel ivy-rich
                     company

                     ;;common utils
                     uuidgen exec-path-from-shell google-this ws-butler iedit fuzzy autopair
                     yasnippet yasnippet-snippets
                     dumb-jump xterm-color interleave dired-narrow smex wgrep

                     ;;VCS management
                     ahg magit

                     ;;custom modes
                     dockerfile-mode docker-compose-mode undo-tree yaml-mode

                     ;;code complete
                     company-quickhelp
                     ))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(eval-when-compile
  (require 'use-package))

;;date time zone----------------
(setq-default datetime-timezone 'Europe/Moscow)

;;tramp -----------------------
(use-package tramp
  :ensure nil
  :config
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
  (add-to-list 'default-frame-alist '(font . "Hack-10"))

  :config
  (load-theme 'nova t)
  (global-hl-line-mode t)
  (show-paren-mode 1)
  (autopair-global-mode)

  (setq-default indent-tabs-mode nil)

  (setq show-paren-style 'expression
        column-number-mode t
        visible-bell t
        inhibit-startup-message t
        scroll-step 1
        toggle-truncate-lines t ;; dont fit long line in buffer
        truncate-partial-width-windows t
        make-backup-files nil;; do (not )ot make backup files
        create-lockfiles nil
        auto-save-default nil
        )
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (fset 'yes-or-no-p 'y-or-n-p)

  ;; fixing some perfomance issues with long lines of base64 text
  (setq-default auto-window-vscroll nil)
  (setq-default line-move-visual nil)

  (set-face-background 'default "#353535")
  (set-face-attribute 'cursor  nil :background "white")
  (set-face-attribute 'region nil :background "#399948f45199")
  (set-face-attribute 'hl-line nil :background "dim gray")
  (set-face-attribute 'highlight nil
                      :background (color-darken-name (face-background 'default) 10))

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
  :after ediff
  :config
  (set-face-attribute 'diff-added nil
                      :foreground "white" :background "DarkGreen")
  (set-face-attribute 'diff-removed nil
                      :foreground "white" :background "DarkRed")
  (set-face-attribute 'diff-changed nil
                      :foreground "white" :background "dim gray")

  ;;EDiff---------------------------------------------------------
  (setq ediff-split-window-function 'split-window-horizontally)
  )

(when (require 'so-long nil :noerror)
   (global-so-long-mode 1))

;; grep setup-------------
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

;; Load sessions--------------
(setq desktop-restore-eager 7
      desktop-load-locked-desktop t
      special-display-buffer-names nil;'("*grep*" "*compilation*" "*clang error")
      special-display-regexps nil
      )

;; mode-line-----------------
(use-package smart-mode-line
  :ensure t

  :config
  (setq  sml/theme 'dark
         sml/mode-width 'full
         sml/name-width 30
         sml/shorten-modes t
         sml/show-frame-identification nil
         sml/shorten-directory t
         sml/replacer-regexp-list '((".+" ""))
         )

  (sml/setup)
  (setq sml/shortener-func (lambda (_dir _max-length) ""))
  (dolist (item '(" ivy-posframe"
                  " company"
                  " ivy"
                  " hs"
                  " yas"
                  " pair"
                  " Undo-Tree"
                  " counsel"
                  " ElDoc"
                  " Dim"
                  " Fly*"
                  " Fly"
                  " Abbrev"
                  " ARev"
                  " ws"
                  " wb"
                  ))
    (add-to-list 'rm-blacklist item)
    )
  )

;; Set Path----------------------------------
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  )

;; IVY competition --------------------------
(use-package ivy
  :ensure t
  :ensure ivy-posframe
  :ensure counsel
  :ensure ivy-rich

  :config
  (ivy-mode 1)
  (ivy-posframe-mode 1)
  (counsel-mode 1)
  (ivy-rich-mode 1)

  (setq-default ivy-use-virtual-buffers t)
  (setq-default ivy-count-format "(%d/%d) ")
  ;; (setq-default ivy-initial-inputs-alist nil)
  ;; (setq-default ivy-re-builders-alist
  ;;               '((t . ivy--regex-fuzzy)))
  (setq-default ivy-posframe-display-functions-alist
                '((t . ivy-posframe-display-at-frame-center)))
  )

;; Project manager --------------------------
(use-package projectile
  :ensure t

  :init
  (projectile-mode +1)

  :config

  (setq-default projectile-indexing-method 'alien);;hybrid
  (setq-default projectile-completion-system 'ivy)
  (setq-default projectile-mode-line-function
                '(lambda ()
                   (format " Proj[%s]" (projectile-project-name))))
  )

;; Dumb jump ---------------------------------
(use-package dumb-jump
  :ensure t
  :config
  (setq-default dumb-jump-max-find-time 10)
  (setq-default dumb-jump-prefer-searcher 'ag)
  (setq-default dumb-jump-selector 'ivy)
  )

;; magit --------------------------------------------
(use-package magit
  :ensure t
  :config
  (set-face-attribute 'magit-diff-context-highlight nil
                      :foreground "nil" :background "nil")
  (set-face-attribute 'magit-diff-context nil
                      :foreground "nil" :background "nil")
  ;; (set-face-attribute 'magit-diff-added-highlight nil
  ;;                     :foreground "red" :background "nil")
  )

;; Company complete --------------------------------------------
(use-package company
  :ensure t

  :bind
  ("M-." . company-complete)

  :init
  (add-hook 'after-init-hook 'global-company-mode)

  :config
  ;; set default `company-backends'
  (setq company-backends
        '((company-files          ; files & directory
           company-yasnippet
           company-dabbrev)
          ))

  (setq company-dabbrev-ignore-case 1)
  (setq company-dabbrev-downcase nil)
  (setq company-dabbrev-char-regexp "\\sw\\|\\s_")

  (setq dabbrev-case-distinction '1)
  (setq dabbrev-case-fold-search 'nil)
  (setq dabbrev-case-replace 'nil)
  )

;; whitespace config --------------------------------------------
(use-package whitespace
  :ensure nil
  :ensure ws-butler
  :after popup

  :config
  (setq whitespace-style (quote (face tabs trailing empty tab-mark)));lines
  (setq whitespace-display-mappings
        '((tab-mark 9 [124 9] [92 9]))) ; 124 is the ascii ID for '\|'
  (setq whitespace-line-column 90)

  (set-face-attribute 'whitespace-line nil :foreground "nil" :overline t)
  (set-face-attribute 'whitespace-tab nil :foreground "dim gray" :background "nil")
  (set-face-attribute 'whitespace-trailing nil :foreground "black" :background "nil")

  (setq ws-butler-keep-whitespace-before-point nil)

  (defun my:force-modes (rule-mode &rest modes)
    "switch on/off several modes depending of state of
    the controlling minor mode
  "
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

;;Cygwin customize ---------------------------------
(cond ((eq system-type 'cygwin)
       (load "~/.emacs.d/lisp/cygwin-mount.el")
       (load "~/.emacs.d/lisp/windows-path.el")
       (require 'windows-path)
       (windows-path-activate)
       (set-file-name-coding-system 'utf-8)
       )
      )

;;Dired-----------------------------------------------------------
(setq dired-listing-switches "-lta");;-lt
(setq directory-free-space-program nil)
(setq-default dired-dwim-target 1)
(define-key dired-mode-map "N" 'dired-narrow-fuzzy)

;;emacs Mercurial--------------------------------------------------
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
  (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
  (setq eshell-output-filter-functions (remove 'eshell-handle-ansi-color eshell-output-filter-functions))

  (defun eshell-new()
    "Open a new instance of eshell."
    (interactive)
    (eshell 'N))
  )

;;Background---------------------------------------------------------
;; (set-face-background 'default "#353535")
;; (set-face-foreground 'default "#efefef")

(defun my-copy-line ()
  (interactive)
  (copy-region-as-kill (line-beginning-position) (line-end-position))
  (end-of-line)
  (newline)
  (yank))

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

;; GLOBAL HOTKEYS----------------------------------------------------------------------------
(global-set-key "\M-x" 'counsel-M-x)
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
(global-set-key "\C-xj" 'dumb-jump-go)
(global-set-key "\M-o" 'other-window)
(global-set-key "\C-xa" 'align)
(global-set-key "\M-q" 'kill-buffer-and-window)
(global-set-key "\M-c" 'clipboard-kill-ring-save)
(global-set-key "\M-d" 'delete-region)
(global-set-key "\C-xg" 'universal-coding-system-argument)
(global-set-key "\C-cf" 'counsel-projectile)
(global-set-key "\M-/" 'comment-or-uncomment-region)
(define-key global-map (kbd "C-c ;") 'iedit-mode)

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
(global-set-key [(control f7)] 'projectile-grep)
(global-set-key [f7] 'projectile-ag)
(global-set-key [(control f8)] 'compile)
(global-set-key [f8] 'projectile-compile-project)
(global-set-key [f9] 'replace-string)
(global-set-key [f10] 'kmacro-end-and-call-macro)
(global-set-key [f11] 'kmacro-start-macro)
(global-set-key [f12] 'kmacro-end-macro)

(global-set-key "\C-cms" 'magit-status)
(global-set-key "\C-cml" 'magit-log-all)
(global-set-key "\C-xm" nil)
