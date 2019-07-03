;; Theme--------------------
(load-theme 'nova t)
(global-hl-line-mode t)
(set-scroll-bar-mode nil)
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

(defun find-file-at-point-with-line()
  "if file has an attached line num goto that line, ie boom.rb:12"
  (interactive)
  (setq line-num 0)
  (save-excursion
    (search-forward-regexp "[^ ]:" (point-max) t)
    (if (looking-at "[0-9]+")
         (setq line-num (string-to-number (buffer-substring (match-beginning 0) (match-end 0))))))
  (find-file-at-point)
  (if (not (equal line-num 0))
      (goto-line line-num)))

(setq logview-additional-level-mappings
      '(("test-log-level"
         (error "error" "ERROR")
         (warning "warning" "WARNING")
         (information "info" "INFO")
         (debug "debug")
         (trace "trace"))))

(setq logview-additional-submodes
      '(("Test"
         (format . "TIMESTAMP LEVEL [NAME] MESSAGE")
         (levels . "test-log-level"))))

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

;(add-to-list 'default-frame-alist '(font . "Hack-10"))
(setq-default indent-tabs-mode nil)

;; fixing some perfomance issues with long lines of base64 text
(setq-default auto-window-vscroll nil)
(setq-default bidi-display-reordering nil)
(setq-default line-move-visual nil)

;; grep setup-------------
(setq grep-command "grep -nH -e "
      grep-find-command "grep -rnH --exclude=.hg --include=*.{c,cpp,h,R,qml} --include=-e 'pattern'"
      grep-highlight-matches `auto
      grep-use-null-device nil
      grep-template "grep <X> <C> -nH -e <R> <F>"
      )

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

;; Set Path----------------------------------
(exec-path-from-shell-initialize)

;; magit github\gitlab integreation
;(with-eval-after-load 'magit
;  (require 'forge))

;; IDO mode ----------------------------------------------
(setq ido-enable-flex-matching nil
      ido-create-new-buffer `always
      ido-everywhere 1
      ido-work-directory-match-only t
      )
(ido-mode 1)

(require 'smex)
(smex-initialize)

;;Auto-complete ------------------------in process of deprecating
(require 'auto-complete)
(require 'auto-complete-config)
;(ac-config-default)

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
  (define-key ac-complete-mode-map  "\t" nil)
;  (define-key ac-mode-map  [(meta return)] 'ac-complete-filename)
  ;(local-set-key  [(control return)] 'auto-complete)
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

;; Company complete --------------------------------------------
(require 'company)

;; set default `company-backends'
(setq company-backends
      '((company-files          ; files & directory
         company-keywords       ; keywords
         company-capf
         company-yasnippet
         )
        (company-abbrev company-dabbrev)
        ))

(add-hook 'after-init-hook 'global-company-mode)
(setq company-dabbrev-downcase nil)
;(define-key global-map [(meta return)] 'company-files)
;(define-key global-map [(meta return)] 'company-complete)
(define-key global-map [(meta .)] 'company-complete)
;(global-set-key (kbd "C-") 'company-complete)

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
  (set-face-attribute 'whitespace-tab nil :foreground "dim gray" :background nil)
; (set-face-attribute 'whitespace-line nil :foreground nil :overline t)
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


;;Autopair---------------------------------------------------------
(autopair-global-mode)

;;EDiff---------------------------------------------------------
(setq ediff-split-window-function 'split-window-horizontally)

;;Projman-------------------------------------------------------
(load-file "~/.emacs.d/projman.el")
(load-file "~/.emacs.d/mode-projman.el")
(projman-mode)

;;emacs-NAV---------------------------------------------------------
(require 'nav)
(setq nav-boring-file-regexps
      (quote
       ("^[.][^.].*$" "^[.]$" "~$" "[.]elc$" "[.]pyc$" "[.]o$" "[.]bak$" "^_MTN$" "^blib$" "^CVS$" "^RCS$" "^SCCS$" "^_darcs$" "^_sgbak$" "^autom4te.cache$" "^cover_db$" "^_build$" "moc_*" "ui_*")))
      
;;emacs Mercurial--------------------------------------------------
(require 'ahg)

;; Compilation color customization-----------------------------------

(setq compilation-environment '("TERM=xterm"))

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

;;  Don't forget to setenv TERM xterm-256color

(add-hook 'compilation-start-hook
          (lambda (proc)
            ;; We need to differentiate between compilation-mode buffers
            ;; and running as part of comint (which at this point we assume
            ;; has been configured separately for xterm-color)
            (when (eq (process-filter proc) 'compilation-filter)
              ;; This is a process associated with a compilation-mode buffer.
              ;; We may call `xterm-color-filter' before its own filter function.
              (set-process-filter
               proc
               (lambda (proc string)
                 (funcall 'compilation-filter proc
                          (xterm-color-filter string)))))))

;; Long Lines processing--------------------------------------------

(defun tserg/compilation-long-hook ()
  ;; (fundamental-mode)
  (flyspell-mode -1)
  (yas/minor-mode -1)
  (setq compilation-error-regexp-alist
        (delete 'maven compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'java compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'ada compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'aix compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'ant compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'borland compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'iar compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'ibm compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'irix compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'oracle compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'php compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'rxp compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'sparc-pascal-file compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'sparc-pascal-line compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'sparc-pascal-example compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'sun compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'sun-ada compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'watcom compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'cucumber compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'ruby-Test::Unit compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'mips-1 compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'mips-2 compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'perl--Pod::Checker compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'perl--Test compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'perl--Test2 compilation-error-regexp-alist))
  (setq compilation-error-regexp-alist
        (delete 'perl--Test::Harness compilation-error-regexp-alist))
   )
(add-hook 'compilation-mode-hook 'tserg/compilation-long-hook)

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
 toggle-truncate-lines 1
 truncate-partial-width-windows nil
 make-backup-files nil;; do (not )ot make backup files
 ;; compilation-scroll-output 1
 compilation-skip-threshold 2;;skip warnings
 compilation-scroll-output 'first-error
 )

(setq revert-without-query (quote (".*.pdf")))
(setq nav-width 25)
(menu-bar-mode -1)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
;; (cua-selection-mode 1)
;; (setq cua-delete-selection nil)
;; (setq cua-enable-cua-keys nil)
;; ;; (setq cua-mode t nil '(cua-base))
;; (setq cua-rectangle-mark-key " ") 

;;
;; base64 and utf8 functions
;;
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


;; GLOBAL HOTKEYS----------------------------------------------------------------------------
(global-set-key "\M-x" 'smex)
(global-set-key "\C-c\C-g" 'google-this)
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
(global-set-key [f4] 'eshell-new)
(global-set-key [f7] 'projman-grep)
(global-set-key [f8] 'compile)
(global-set-key [f9] 'replace-string)
(global-set-key [f10] 'kmacro-end-and-call-macro)
(global-set-key [f11] 'kmacro-start-macro)
(global-set-key [f12] 'kmacro-end-macro)

(global-set-key "\C-cms" 'magit-status)
(global-set-key "\C-cml" 'magit-log-all)
(global-set-key "\C-xm" nil)
