;;Auto-complete ------------------------------------------
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

(defun tserg/ac-config ()
  (setq ac-auto-start nil)
  (setq ac-dwim t)                        ;Do what i mean
  (setq ac-override-local-map nil)        ;don't override local map
  (setq ac-fuzzy-enable t)
  ;; (setq ac-auto-show-menu 0.2)
  (setq ac-ignore-case t)
  (setq ac-delay 0)
  (setq ac-use-fuzzy t)
  (setq ac-use-comphist 0)
  (define-key ac-mode-map  [(meta return)] 'ac-complete-filename)
  (local-set-key  [(control return)] 'auto-complete)
  (setq-default ac-sources '(
                             ac-source-abbrev
                             ac-source-dictionary
                             ac-source-words-in-same-mode-buffers 
                             ac-source-files-in-current-dir
                             )
                )
  )
  
(add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
(add-hook 'auto-complete-mode-hook 'ac-common-setup)
(add-hook 'auto-complete-mode-hook  'tserg/ac-config)

;;Yasnippet ----------------------------------------------
(require 'yasnippet)
(yas-global-mode 1)

;; Auto Encode buffer -----------------------------------
(load-file "~/.emacs.d/unicad.el")

;; PowerLine --------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/powerline")
(require 'powerline)
(powerline-default-theme)

;;Autopair---------------------------------------------------------
(load "~/.emacs.d/autopair.el")
(autopair-global-mode)

;;EDiff---------------------------------------------------------
(setq ediff-split-window-function 'split-window-horizontally)

;;Projman-------------------------------------------------------
(load-file "~/.emacs.d/projman.el")
(load-file "~/.emacs.d/mode-projman.el")

;;emacs-NAV---------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/emacs-nav-49/")
(require 'nav)

;;Background---------------------------------------------------------
(set-face-background 'default "#353535")
(set-face-foreground 'default "#efefef")

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
 make-backup-files nil;; do (not )ot make backup files
 compilation-scroll-output 1
 ;; compilation-scroll-output 'first-error
 )

(setq-default indent-tabs-mode nil)
(setq nav-width 25)
(menu-bar-mode -1)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)

;; GLOBAL HOTKEYS----------------------------------------------------------------------------
(global-set-key "\M-n" 'forward-paragraph)
(global-set-key "\M-p" 'backward-paragraph)
(global-set-key "\C-xl" 'my-copy-line)
(global-set-key "\C-xd" 'my-kill-line)
(global-set-key "\C-xcr" 'revert-buffer)
(global-set-key "\C-xcc" 'mywithcp1251)
(global-set-key "\C-xcu" 'mywithutf8)
(global-set-key "\C-xp" 'goto-match-paren)
(global-set-key "\C-x\C-f" 'ido-find-file)
(global-set-key "\M-o" 'other-window)
(global-set-key "\C-xa" 'align)
(global-set-key "\M-q" 'kill-buffer-and-window)
(global-set-key "\M-j" 'pop-global-mark)
(global-set-key "\M-c" 'clipboard-kill-ring-save)
(global-set-key "\C-k" 'kill-region)
(global-set-key "\M-d" 'delete-region)
(global-set-key "\C-xg" 'universal-coding-system-argument)
(global-set-key "\C-xr" 'regexp-builder)
(global-set-key "\C-cf" 'projman-find-file)
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

(global-set-key [f3] 'nav)
(global-set-key [f4] 'eshell)
(global-set-key [f7] 'projman-grep)
(global-set-key [f8] 'compile)
(global-set-key [f9] 'replace-string)
(global-set-key [f10] 'kmacro-end-and-call-macro)
(global-set-key [f11] 'kmacro-start-macro)
(global-set-key [f12] 'kmacro-end-macro)

(custom-set-variables
 '(whitespace-style
   (quote
    (face tabs trailing empty tab-mark lines)))
 '(grep-highlight-matches (quote auto))
 '(special-display-buffer-names (quote ("*grep*")))
 '(special-display-regexps nil)
 '(scroll-bar-mode (quote nil))
 '(show-paren-mode t)
 '(standard-indent 4)
 '(global-hl-line-mode t)
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 98 :width normal))))
 '(cursor ((t (:background "white"))))
 '(ecb-default-highlight-face ((((class color) (background dark)) (:background "#838592"))))
 '(ecb-tag-header-face ((((class color) (background dark)) (:background "#838592"))))
 '(flycheck-error-list-highlight ((t (:inherit highlight :background "#504b4b"))))
 '(header-line ((t (:inherit mode-line :background "dim gray" :foreground "grey90" :box nil))))
 '(highlight ((((class color) (min-colors 88) (background dark)) (:background "#c4c4c4"))))
 '(hl-line ((t (:inherit highlight :background "#504b4b"))))
 '(powerline-active1 ((t (:inherit mode-line :background "grey22" :foreground "gainsboro"))))
 '(region ((t (:background "#3a9890")))))
