(custom-set-variables
 '(org-startup-folded nil)
 '(org-log-done t)
 '(org-src-fontify-natively t)
 '(org-confirm-babel-evaluate nil)
 )

(require 'org)
(require 'ob-python)
(require 'ob-async)

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)
    (ipython . t)
    (sh . t)
    (latex . t)
    (R . t)
    ))

;; Fix an incompatibility between the ob-async and ob-ipython packages
(setq ob-async-no-async-languages-alist '("ipython"))

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|/TODO\\)$" . org-mode))
(add-to-list 'file-coding-system-alist (cons "\\.\\(org\\|org_archive\\|/TODO\\)$"  'utf-8))


(defvar org-blocks-hidden nil)

(defun org-toggle-blocks ()
  (interactive)
  (if org-blocks-hidden
      (org-show-block-all)
    (org-hide-block-all))
  (setq-local org-blocks-hidden (not org-blocks-hidden)))

;; PDFs visited in Org-mode are opened in Evince (and not in the default choice) https://stackoverflow.com/a/8836108/789593
(defun tserg/org-mode-hook ()
  (require 'ox-latex)
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
                 '("myarticle"
                   "\\documentclass{article}
[NO-DEFAULT-PACKAGES]
\\usepackage[utf8x]{inputenc}
\\usepackage[T2A]{fontenc}
\\usepackage[russian,english]{babel}
\\usepackage{graphicx}
\\usepackage{longtable}
\\usepackage{hyperref}
\\usepackage{natbib}
\\usepackage{amssymb}
\\usepackage{amsmath}
\\usepackage{geometry}
\\geometry{a4paper,left=2.5cm,top=2cm,right=2.5cm,bottom=2cm,marginparsep=7pt, marginparwidth=.6in}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
    ;; (add-to-list 'org-file-apps '("\\.pdf\\'" . "org-pdfview-open"))
    )
  (define-key org-mode-map (kbd "C-c t") 'org-toggle-blocks)
  (delete '("\\.pdf\\'" . default) org-file-apps)
  (add-to-list 'org-file-apps '("\\.pdf\\'" . "evince %s"))
  )
  
  (add-hook 'org-mode-hook 'tserg/org-mode-hook)
