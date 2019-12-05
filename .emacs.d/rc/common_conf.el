;; Packages list needed--------------------------
(setq package-list '(;;theme specific
                     auto-dim-other-buffers smart-mode-line nova-theme

                     ;;project management
                     projectile projectile-ripgrep counsel-projectile

                     ;;ui complete
                     ivy ivy-posframe counsel
                     company

                     ;;common utils
                     uuidgen exec-path-from-shell google-this ws-butler iedit fuzzy autopair
                     yasnippet yasnippet-snippets yasnippet-classic-snippets
                     dumb-jump xterm-color interleave dired-narrow smex

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


;;date time zone----------------
(setq-default datetime-timezone 'Europe/Moscow)

;; undo tree mode --------------
(undo-tree-mode)
(add-to-list 'display-buffer-alist
             `("*undo-tree*"
               (display-buffer-reuse-window
                display-buffer-in-side-window)
               (reusable-frames . visible)
               (side            . left)
               (window-width   . 0.1)))

;; Theme--------------------
(load-theme 'nova t)
(global-hl-line-mode t)
;(set-scroll-bar-mode nil)
(show-paren-mode 1)
;(set-face-attribute 'default nil :background "#353535")
(set-face-background 'default "#353535")
(auto-dim-other-buffers-mode t)
(set-face-attribute 'auto-dim-other-buffers-face nil
                    :foreground (color-darken-name (face-foreground 'default) 5)
                    :background (color-darken-name (face-background 'default) 2))
(set-face-attribute 'region nil
                    :foreground nil
                    :background "#399948f45199")
(set-face-attribute 'hl-line nil :foreground nil :background "dim gray")
(set-face-attribute 'highlight nil
                    :foreground nil
                    :background (color-darken-name (face-background 'default) 10))
(set-face-attribute 'cursor  nil :foreground nil :background "white")

(defun update-diff-colors ()
  "update the colors for diff faces"
  (set-face-attribute 'diff-added nil
                      :foreground "white" :background "DarkGreen")
  (set-face-attribute 'diff-removed nil
                      :foreground "white" :background "DarkRed")
  (set-face-attribute 'diff-changed nil
                      :foreground "white" :background "dim gray")
  )
(eval-after-load "diff-mode"
  '(update-diff-colors))

(add-to-list 'default-frame-alist '(font . "Hack-9"))
(setq-default indent-tabs-mode nil)

;; fixing some perfomance issues with long lines of base64 text
(setq-default auto-window-vscroll nil)
(setq-default bidi-display-reordering nil)
(setq-default line-move-visual nil)

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
                " Dim"
                " Fly*"
                " Fly"
                " Abbrev"
                " ws"
                " wb"
                ))
  (add-to-list 'rm-blacklist item)
  )


;; Set Path----------------------------------
(exec-path-from-shell-initialize)

;; IVY competition --------------------------
(require 'ivy-posframe)
(ivy-mode 1)
(ivy-posframe-mode 1)

(setq-default ivy-use-virtual-buffers t)
(setq-default ivy-count-format "(%d/%d) ")
;; (setq-default ivy-initial-inputs-alist nil)
;; (setq-default ivy-re-builders-alist
;;               '((t . ivy--regex-fuzzy)))
(setq-default ivy-posframe-display-functions-alist
              '((t . ivy-posframe-display-at-frame-center)))

;; counsel set up --------------------
(require 'counsel)
(counsel-mode 1)
(setq-default counsel-grep-base-command
      "rg -i -M 120 --no-heading --line-number --color never '%s' %s")


;; Project manager --------------------------
(projectile-mode 1)
(setq-default projectile-completion-system 'ivy)
(setq-default projectile-mode-line-function
              '(lambda ()
                 (format " Proj[%s]" (projectile-project-name))))

;; Dumb jump ---------------------------------
(setq-default dumb-jump-max-find-time 10)
(setq-default dumb-jump-prefer-searcher 'rg)
(setq-default dumb-jump-selector 'ivy)

;; magit --------------------------------------------
(with-eval-after-load 'magit
  ;  (require 'forge)
  (set-face-attribute 'magit-diff-context-highlight nil
                      :foreground "nil" :background "nil")
  (set-face-attribute 'magit-diff-context nil
                      :foreground "nil" :background "nil")
  ;; (set-face-attribute 'magit-diff-added-highlight nil
  ;;                     :background "")
  )

;; Company complete --------------------------------------------
(require 'company)

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

(add-hook 'after-init-hook 'global-company-mode)
(define-key global-map [(meta .)] 'company-complete)

;; whitespace config --------------------------------------------

(defun my:force-modes (rule-mode &rest modes)
  "switch on/off several modes depending of state of
    the controlling minor mode
  "
  (let ((rule-state (if rule-mode 1 -1)
       ))
    (mapcar (lambda (k) (funcall k rule-state)) modes)
  )
)

(require 'whitespace)

(defun tserg/whitespace-mode ()
  (interactive "P")
  (setq whitespace-style (quote (face tabs trailing empty tab-mark)));lines
  (setq whitespace-display-mappings
        '((tab-mark 9 [124 9] [92 9]))) ; 124 is the ascii ID for '\|'
  (setq whitespace-line-column 90)
  (set-face-attribute 'whitespace-trailing nil :foreground "black" :background nil)
  (set-face-attribute 'whitespace-tab nil :foreground "dim gray" :background nil)
  (set-face-attribute 'whitespace-line nil :foreground nil :overline t)
  )

(add-hook 'whitespace-mode-hook 'tserg/whitespace-mode)

(setq ws-butler-keep-whitespace-before-point nil)

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

(require 'popup)
(advice-add 'popup-draw :before #'my:push-whitespace)
(advice-add 'popup-delete :after #'my:pop-whitespace)

;;Yasnippet ----------------------------------------------
(require 'yasnippet)
(yas-global-mode 1)

;; Auto Encode buffer -----------------------------------
(load-file "~/.emacs.d/unicad.el")

;;Cygwin customize ---------------------------------
(cond ((eq system-type 'cygwin)
       (load "~/.emacs.d/cygwin-mount.el")
       (load "~/.emacs.d/windows-path.el")
       (require 'windows-path)
       (windows-path-activate)
       (set-file-name-coding-system 'utf-8)
       )
      )

;;Autopair---------------------------------------------------------
(autopair-global-mode)

;;EDiff---------------------------------------------------------
(setq ediff-split-window-function 'split-window-horizontally)

;;Dired-----------------------------------------------------------
(setq dired-listing-switches "-lt");;-lt
(setq directory-free-space-program nil)
(setq-default dired-dwim-target 1)
(define-key dired-mode-map "N" 'dired-narrow-fuzzy)

;;emacs Mercurial--------------------------------------------------
(require 'ahg)
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

;; shell color customization------------------------------------------
(setq comint-output-filter-functions
      (remove 'ansi-color-process-output comint-output-filter-functions))

(add-hook 'shell-mode-hook
          (lambda () (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t)))

;; You can also use it with eshell (and thus get color output from system ls):

(require 'eshell)

(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

(add-hook 'eshell-before-prompt-hook
          (lambda ()
            (setq xterm-color-preserve-properties t)))

(add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
(setq eshell-output-filter-functions (remove 'eshell-handle-ansi-color eshell-output-filter-functions))


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

(setq show-paren-style 'expression
      column-number-mode t
      visible-bell t
      inhibit-startup-message t
      scroll-step 1
      toggle-truncate-lines t ;; dont fit long line in buffer
      truncate-partial-width-windows t
      make-backup-files nil;; do (not )ot make backup files
      )

(setq revert-without-query (quote (".*.pdf")))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)

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
(global-set-key "\C-xvu" 'undo-tree-visualize)
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
