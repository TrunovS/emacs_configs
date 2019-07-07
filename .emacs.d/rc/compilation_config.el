;; Compilation color customization-----------------------------------

(setq compilation-environment '("TERM=xterm"))

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

;; Reuse Compilation ----------------------------------------
(push '("\\*compilation\\*" . (nil (reusable-frames . t))) display-buffer-alist)


(add-hook 'compilation-mode-hook 'tserg/compilation-long-hook)
