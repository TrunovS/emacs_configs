(use-package js-mode
  :ensure flycheck

  :if (eq system-type 'darwin)
  :ensure-system-package
  ("jsonlint" . "brew install jsonlint")

  :mode ("\\.js" . js-mode)
  ("\\.json" . js-mode)

  :init
  (require 'flycheck)
  (flycheck-add-mode 'json-jsonlint 'js-mode)
  (add-hook 'js-mode-hook 'flycheck-mode)
  )
