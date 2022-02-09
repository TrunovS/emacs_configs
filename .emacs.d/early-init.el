;; mode-line-----------------
(setq-default mode-line-percent-position '(:eval ""))
(setq-default mode-line-end-spaces
              '(
                (:eval (car mode-line-modes)) ; insert [compiling] identification here
                " "
                (vc-mode vc-mode)
                 " | "
                (:eval
                 (symbol-name buffer-file-coding-system))
                " | "
                (:eval
                 (pcase (coding-system-eol-type buffer-file-coding-system)
                   ('0 "LF")
                   ('1 "CRLF")
                   ('2 "CR")
                   (_ "")
                   )
                 )
                ))

(defun tserg/mode-line/padding ()
  (let ((r-length (length (format-mode-line mode-line-end-spaces))))
    (propertize " "
                'display `(space :align-to (- right ,r-length)))))

(setq-default mode-line-format '("%e" mode-line-front-space

                                 mode-line-client

                                 (:eval ;; input method indicator-------------
                                  (cond ((not current-input-method-title) "EN|")
                                        (t (concat current-input-method-title "|"))))

                                 (:eval ;; read only buffer
                                  (cond (buffer-read-only " ")
                                        (t "  ")))

                                 (:eval ;; modified buffer
                                  (cond ((buffer-modified-p) " ●")
                                        (t " ○")))

                                 (:eval ;; remote vs local indicator
                                  (cond ((not buffer-file-truename) "")
                                        ((file-remote-p buffer-file-truename) " @")
                                        (t ""))
                                  )
                                 mode-line-frame-identification mode-line-buffer-identification
                                 "  " (:eval (cdr mode-line-modes)) ; do not insert [compiling] identification here
                                 " " mode-line-position mode-line-misc-info

                                 (:eval (tserg/mode-line/padding))
                                 mode-line-end-spaces
                                 ))
(setq-default mode-line-compact nil)

;; emacs 28 process api changes fixes -------------------------------
(when (eval-when-compile (version< "28" emacs-version ))
  (setq-default native-comp-async-report-warnings-errors 'silent)
  (defun start-file-process-shell-command@around (start-file-process-shell-command name buffer &rest args)
    "Start a program in a subprocess.  Return the process object for it. Similar to `start-process-shell-command', but calls `start-file-process'."
    (let ((command (mapconcat 'identity args " ")))
      (funcall start-file-process-shell-command name buffer command)))

  (advice-add 'start-file-process-shell-command :around #'start-file-process-shell-command@around)
  )
