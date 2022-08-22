(use-package js-mode
  :ensure nil

  :ensure flycheck

  :no-require t ;;defered config read
  :defer t ;;defered config read

  :mode ("\\.js" . js-mode)
  ("\\.json" . js-mode)

  :config

  (eval-when-compile

    :if (eq system-type 'darwin)
    :ensure-system-package
    ("jsonlint" . "brew install jsonlint")

    (require 'flycheck)
    (flycheck-add-mode 'json-jsonlint 'js-mode)
    (add-hook 'js-mode-hook 'flycheck-mode)
    )

  (whitespace-mode 1)
  (ws-butler-mode 1)
  (smart-tabs-mode 0)
  )
