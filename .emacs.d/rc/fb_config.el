(defun bread-mode()
  (sgml-mode)
  (sgml-tags-invisible 0)
  (longlines-mode)
  (view-mode)
  )

(add-to-list 'auto-mode-alist '("\\.fb2\\'" . bread-mode))
