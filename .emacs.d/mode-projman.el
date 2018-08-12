(require 'projman)

(add-to-list 'projman-types '(cake "cake" ("*.php" "*.ctp" "*.org" "*.js")))
(add-to-list 'projman-types '(clojure "clojure" ("*.clj" "*.html" "*.js" "*.css")))
(add-to-list 'projman-types '(rust "rust" ("*.rs" "Cargo*")))

;; macros for directory local variables(usefull for projects that's why I placed
;; them here)
(defun absolute-dirname (path)
  "Return the directory name portion of a path.

If PATH is local, return it unaltered.
If PATH is remote, return the remote diretory portion of the path."
  (cond ((tramp-tramp-file-p path)
         (elt (tramp-dissect-file-name path) 3))
        (t path)))

(defun dir-locals (dir vars)
  "Set local variables for a directory.

DIR is the base diretory to set variables on.

VARS is an alist of variables to set on files opened under DIR,
in the same format as `dir-locals-set-class-variables' expects."
  (let ((name (intern (concat "dir-locals-"
                              (md5 (expand-file-name dir)))))
        (base-dir dir)
        (base-abs-dir (absolute-dirname dir)))
    (dir-locals-set-class-variables name vars)
    (dir-locals-set-directory-class dir name nil)))

;; ;; Example of dir locals:
;;(dir-locals "~/work/rtos/openVE/trunk/projects/vm_as_library/Source/program"
;; (list (cons nil (list (cons 'compile-command "make -k")))))
;;(dir-locals (projman-project-root)
;; (list (cons nil (list (cons 'compile-command (projman-project-compile-command))))))

(defun projman-find-file (&optional regen)
  "Switch to another project buffer using iswitchb.
Prefix arg non-nil to force a refresh of the cached file list.
Text displayed in two columns : left - name of file, right - full
path to file relative to root of project. Also perform remapping
<left> and <right> keys to the <up> and <down> respectively. This
settings specific only for ergonomic keymap. "
  (interactive "P")
  (let ((filelist (projman-project-files-from-cache regen))
        (ido-common-completion-map ido-common-completion-map)
        files choice ido-decorations ido-max-window-height )
    (setq ido-decorations (quote ("\n-> " "" "\n " "\n ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
    (setq ido-max-window-height 30)
    (setq files (mapcar #'(lambda (f) (list (concat
                                             (file-name-nondirectory f)
                                             (make-string (- 70 (length (file-name-nondirectory f))) (string-to-char " "))
                                             "|"
                                             (file-relative-name f (projman-project-root)))
                                            f))
                        filelist))
    (setq choice (ido-completing-read "Project file: " (mapcar 'car files)))
    (find-file (cadr (assoc choice files)))))

(defun projman-switch-to-active-buffer ()
  (interactive)
  (let (choice files filelist)
    (setq filelist (append (projman-active-buffers)
                           (projman-active-shell-buffers)))
    (setq files (mapcar #'(lambda (f) (list (buffer-name f) f)) filelist))
    (setq choice (ido-completing-read "Active buffer: " files))
    (switch-to-buffer (cadr (assoc choice files)))))

(defun projman-active-buffers ()
  (let ((proj-file-re (concat "^" (regexp-quote (expand-file-name (projman-project-root-safe)))))
        (case-fold-search (if (projman-w32p) t case-fold-search))
        bufs)
    (dolist (b (buffer-list) bufs)
      (let ((bufname (buffer-name b))
            (filename (buffer-file-name b)))
        (if (or (and filename
                     (string-match proj-file-re (expand-file-name filename))
                     (not (string-match projman-buffers-not-to-save bufname)))
                (with-current-buffer b
                  (and (eq major-mode 'dired-mode)
                       (string-match proj-file-re (expand-file-name default-directory)))))
            (setq bufs (cons b bufs)))))
    (nreverse bufs)))

;; function that return list of all shell buffers that have default directory
;; inside current project
(defun projman-active-shell-buffers ()
  (let ((proj-file-re (concat "^" (regexp-quote (expand-file-name (projman-project-root-safe)))))
        bufs)
    (dolist (b (buffer-list) bufs)
      (let ((bufname (buffer-name b)))
        (if (with-current-buffer b
              (and (eq major-mode 'shell-mode)
                   (string-match proj-file-re (expand-file-name default-directory))))
            (setq bufs (cons b bufs)))))
    (nreverse bufs)))

(defun projman--read-projname ()
  (let* ((choices (delete-dups
                   (append (mapcar 'car projman-projects)
                           (mapcar 'car projman-temp-projects)
                           (and projman-use-active-file
                                (projman--active-files)))))
         (iswitchb-use-virtual-buffers nil)
         (iswitchb-make-buflist-hook
          (lambda () (setq iswitchb-temp-buflist choices))))
    (ido-completing-read "Choose Project: " choices)))

(setq projman-close-buffers-when-close-project t)

(setq projman-opened-projects nil)

(defun projman-switch-project-preserve (&optional projname)
  "Switch to a different project. If project is in the list of
currenly active projects - just set options for it, and don't
close buffers of currently active project(something like
suspend). Saves any current project first."
  (interactive (list (projman--read-projname)))
  ;; save current project in list of active projects
  (add-to-list 'projman-opened-projects projman-current-project)
  (if (assoc projname projman-opened-projects)
      ;; project buffers already loaded - need only set options
      (progn
        (let ((proj (assoc projname projman-projects)))
          (setq projman-current-project proj)
          (setq projman-project-name (projman-project-name))
          (message "Switched to project %s" (projman-project-name)))
        (projman-setup-project-options)
        ;; regen files list
        (setq projman-file-cache (projman-project-files))
        (let ((hook (projman-project-open-hook)))
          (if hook (funcall hook))))
    ;; load project
    (progn
      (let ((proj (or (assoc projname projman-projects)
                      (assoc projname projman-temp-projects)
                      (and projman-use-active-file
                           (member projname (projman--active-files))
                           (car (setq projman-temp-projects
                                      (cons (list projname) projman-temp-projects))))
                      (or (and (y-or-n-p
                                (format "Project %s does not exist. Create it? "
                                        projname))
                               (projman-create-project projname t))
                          (error "Canceled")))))
        (setq projman-current-project proj)
        (setq projman-project-name (projman-project-name)))
      (message "Switched to project %s" (projman-project-name))
      (let (options buffers)
        (if projman-use-active-file
            ;; state is cons: (options . (active buffers info))
            (let ((state (projman-load-active-state (projman-project-name))))
              (setq options (car state))
              (setq buffers (cdr state))))
        (projman-restore-options options)
        ;; sanity checks
        (unless (projman-project-root)
          (setq projman-current-project nil
                projman-project-name nil)
          (error "ERROR: project has not root defined"))
        (message "For directory %s : set command %s" (projman-project-root) (projman-project-compile-command))
        ;; (dir-locals (projman-project-root)
        ;; (list (cons nil (list (cons 'compile-command (projman-project-compile-command))))))
        ;; make sure all options are setup before loading any buffers
        (projman-setup-project-options)
        (setq projman-file-cache (projman-project-files))
        (projman-restore-buffers buffers))
      (run-hooks 'projman-project-switch-hook)
      (let ((hook (projman-project-open-hook)))
        (if hook (funcall hook))))))

(defun projman-setup-project-options ()
  (let ((tagfiles (projman-project-tag-files)))
    (if (null tagfiles)
        (setq tags-file-name (expand-file-name "TAGS" (projman-project-root))
              tags-table-list nil)
      (setq tags-file-name nil
            tags-table-list (cons
                             (projman-project-root)
                             (projman-project-tag-files)))))
  (let ((gtaglibs (projman-project-gtag-libs)))
    (setenv "GTAGSLIBPATH" (mapconcat 'identity gtaglibs ";"))))

(defun projman-save-active-state (projname state)
  (let* ((file (concat (expand-file-name projman-active-directory)
                       projname)))
    (save-excursion
      (set-buffer (get-buffer-create " *Saved State*"))
      (delete-region (point-min) (point-max))
      (let ((print-length nil)
            (print-level nil))
        (insert ";; Created by projman on " (current-time-string) ".")
        (print state (current-buffer)))
      (let ((version-control
             (cond ((null projman-version-control) nil)
                   ((eq 'never projman-version-control) 'never)
                   ((eq 'nospecial projman-version-control) version-control)
                   (t t))))
        (condition-case nil
            ;; Don't use write-file; we don't want this buffer to visit it.
            (write-region (point-min) (point-max) file)
          (file-error (message "Can't write %s" file)))
        (kill-buffer (current-buffer))
        (sit-for 3)))))

(add-to-list 'safe-local-variable-values '(compile-command . "make"))

(provide 'mode-projman)
