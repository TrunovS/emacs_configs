;; Packages list needed--------------------------
(setq compilation-package-list '(multi-compile))

(use-package compile
  :ensure nil

  :config

  ;; install the missing packages
  (dolist (package compilation-package-list)
    (unless (package-installed-p package)
      (package-install package)))

  (setq tserg/filepath-font-lock-keywords
      (let* (
            (filepath-regexp "[\/A-Za-z\\0-9 _@:]+\\.[a-zA-Z]+[:0-9]*\(?[,0-9]*"))

        `(
          (,filepath-regexp . font-lock-constant-face)
          )))

  ;; multi-compile-----------------------------
  (require 'multi-compile)
  (setq-default multi-compile-completion-system 'ivy)

  ;; Compilation color customization-----------------------------------
  (setq compilation-environment '("TERM=xterm"))

  (setq  ;; compilation-scroll-output 1
   compilation-skip-threshold 2;;skip warnings
   compilation-scroll-output 'first-error
   )

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
    (setq font-lock-defaults '((tserg/filepath-font-lock-keywords)))
    (flyspell-mode -1)
    (yas/minor-mode -1)
    (toggle-truncate-lines 0)
    ;; (setq-local auto-hscroll-mode 'current-line);;emacs version >= 26
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

  ;; Reuse Compilation ----------------------------------------
  (add-to-list 'display-buffer-alist
               `(,(rx bos "*compilation*" eos)
                 (display-buffer-reuse-window
                  display-buffer-in-side-window)
                 (reusable-frames . visible)
                 (side            . right)
                 (window-width   . 0.4)))

  (add-hook 'compilation-mode-hook 'tserg/compilation-long-hook)

  (global-set-key [f8] 'multi-compile-run)
  )
