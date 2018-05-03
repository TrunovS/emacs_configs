;; Python SetPath -------------------------------------------
;; (setq ropemacs-enable-shortcuts nil)
;; (setq ropemacs-local-prefix "C-c C-p")
(require 'pymacs)

(defun tserg/python-mode-hook()
  (interactive)
  (cua-mode 0)
  (pymacs-load "ropemacs" "rope-")
  (setq jedi:setup-keys t)                      ; optional
  (setq jedi:complete-on-dot t)                 ; optional
  (setq jedi:environment-root "jedi")
  (print "hhheee")

  ;; IPython Setup -----------------------------------------------------
  (setenv "IPY_TEST_SIMPLE_PROMPT" "1")
  (setq
   python-shell-interpreter "/usr/bin/ipython3"
   python-shell-interpreter-args "--colors=Linux"
   python-shell-prompt-regexp "In \\[[0-9]+\\]: "
   python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
   python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
   python-shell-completion-module-string-code
   "';'.join(module_completion('''%s'''))\n"
   python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")
  (setq python-environment-default-root-name "jedi")
  )



(custom-set-variables
 '(jedi:install-python-jedi-dev-command
  (quote
   ("pip3" "install" "--upgrade" "git+https://github.com/davidhalter/jedi.git@dev#egg=jedi")))
 )

(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'tserg/python-mode-hook)

