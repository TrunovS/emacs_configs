;; Packages list needed--------------------------
(setq package-list '(rust-mode

                     ;;common utils
                     ws-butler

                     ;;code complete
                     ac-racer racer
                     ))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(require 'rust-mode)

;; (eval-after-load 'flycheck
;;   '(add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(defun tserg/rust-compile-hook ()
  (require 'compile)
  (set (make-local-variable 'compile-command)
       (if (locate-dominating-file (buffer-file-name) "Cargo.toml")
           "cargo run"
         (format "rustc %s && %s" (buffer-file-name)
                 (file-name-sans-extension (buffer-file-name))))))

(defun tserg/racer-mode-hook ()
  ;; cargo install racer
  (setq racer-cmd (expand-file-name "~/.cargo/bin/racer"))
  ;;  rustup component add rust-src
  (setq racer-rust-src-path (expand-file-name "~/.rustup/toolchains/stable\-x86_64\-unknown\-linux\-gnu/lib/rustlib/src/rust/src"))
  (ac-racer-setup)
)

(defun tserg/rust-mode-hook()
  (ws-butler-mode)
  (whitespace-mode)
  (hs-minor-mode)
  ;; (setq-default compilation-read-command nil)
  '(tserg/rust-compile-hook)
  (local-set-key [(control return)] 'ac-complete-racer)
  (define-key rust-mode-map "\C-j" 'racer-find-definition)
  (define-key rust-mode-map "\C-hj" 'racer-describe)
  (define-key hs-minor-mode-map "\M-h\M-t" 'hs-toggle-hiding)
  (define-key hs-minor-mode-map "\M-h\M-a" 'hs-hide-all)
  (define-key hs-minor-mode-map "\M-h\M-s" 'hs-show-all)
  )

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook 'tserg/racer-mode-hook)
(add-hook 'rust-mode-hook 'tserg/rust-mode-hook)
