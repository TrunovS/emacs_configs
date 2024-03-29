;; Packages list needed--------------------------
(use-package logview
  :ensure t ;; auto install on startup only
  :ensure vlf

  ;;defered config read on associated file open
  :no-require t
  :defer t

  :config ;; do after download

  (require 'vlf-setup)

  (setq-default logview-copy-visible-text-only t)
  (setq-default logview-auto-revert-mode t)

  (setq-default logview-additional-timestamp-formats
                '((("yyyy-MMM-dd HH:mm:ss.SSSSSS"
                    (regexp . "[0-9]\\{4\\}-[A-Za-z]\\{3\\}-[0-9]\\{2\\} [0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}.[0-9]\\{6\\}")))))

  (setq-default logview-additional-level-mappings
                '(("log-levels"
                   (error "error" "error   " "ERROR")
                   (warning "warning" "WARNING")
                   (information "info" "info    " "INFO" )
                   (debug "debug" "debug   " "DEBUG")
                   (trace "trace" "TRACE"))))

  (setq-default logview-additional-submodes
                '(("UPG"
                   (format . "[NAME][TIMESTAMP][THREAD][LEVEL][NAME][IGNORED][MESSAGE")
                   (levels . "log-levels")
                   )
                  ("UPGSP"
                   (format . "[NAME][TIMESTAMP][THREAD][LEVEL][MESSAGE")
                   (levels . "log-levels")
                   )
                  ))

  (defun tserg/find-file-at-point-with-line()
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


  (defun tserg/log-common-hook()
    ;; (so-long-mode 1)
    (undo-tree-mode nil)
    (toggle-truncate-lines nil)
    (visual-line-mode nil)
    (logview-choose-submode "UPG" "yyyy-MMM-dd HH:mm:ss.SSSSSS")
    (define-key logview-mode-map "O" 'tserg/find-file-at-point-with-line)
    ;; (vlf-mode)
    )

  (add-hook 'logview-mode-hook 'tserg/log-common-hook)
  )
