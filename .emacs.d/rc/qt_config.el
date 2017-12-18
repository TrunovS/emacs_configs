;; Auto-comlete C++\C headers -------------------------------------------------
(defun tserg/ac-qt-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'achead:include-directories '"/usr/include/qt4/QtGui")
  (add-to-list 'achead:include-directories '"/usr/include/qt4/QtCore")
  (add-to-list 'achead:include-directories '"/usr/include/qt4/QtSql")
  (add-to-list 'achead:include-directories '"/usr/include/qt4/QtSvg")
  (add-to-list 'achead:include-directories '"/usr/include/qt4/QtTest")
  (add-to-list 'achead:include-directories '"/usr/include/qt4/QtNetwork")
  (add-to-list 'achead:include-directories '"/usr/include/qt4/Qt")
  (add-to-list 'achead:include-directories '"/usr/include/qt4")
  ;; (add-to-list 'achead:include-directories '"/usr/include/qwt-qt4")
  )


(defun tserg/set-ac-qt-clang-flags()
  (if (member "-I/usr/include/qt4" ac-clang-flags) 0
    (setq ac-clang-flags
          (append
           (mapcar(lambda (item)(concat "-I" item))
                  (split-string
                   "
 /usr/share/qt4/mkspecs/linux-g++ 
 /usr/include/qt4
 /usr/include/qt4/Qt
 /usr/include/qt4/QtSql
 /usr/include/qt4/QtSvg
 /usr/include/qt4/QtTest
 /usr/include/qt4/QtNetwork
 /usr/include/qt4/QtCore
 /usr/include/qt4/QtGui
"
                   ))
           ac-clang-flags))
    )
  )

;;SEMANTIC INCLUDES---------------------------------------------------------
(setq qt4-base-dir "/usr/include/qt4")
(semantic-add-system-include qt4-base-dir 'c++-mode)
(semantic-add-system-include "/usr/include/qt4/QtCore" 'c++-mode)
(semantic-add-system-include "/usr/include/qt4/Qt" 'c++-mode)
(semantic-add-system-include "/usr/include/qt4/QtSql")
(semantic-add-system-include "/usr/include/qt4/QtSvg")
(semantic-add-system-include "/usr/include/qt4/QtTest")
(semantic-add-system-include "/usr/include/qt4/QtNetwork")
(semantic-add-system-include "/usr/share/qt4/mkspecs/linux-g++" 'c++-mode)
(semantic-add-system-include "/usr/include/qt4/QtGui" 'c++-mode)
(semantic-add-system-include "/usr/include/qt4" 'c++-mode)
;; (semantic-add-system-include "/usr/include/qwt-qt4" 'c++-mode)

(add-to-list 'auto-mode-alist (cons qt4-base-dir 'c++-mode))
(defvar semantic-lex-c-preprocessor-symbol-file '())
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig.h"))
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-dist.h"))
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qglobal.h"))
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-dist.h"))
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-large.h"))
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-medium.h"))
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-minimal.h"))
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-small.h"))
(defvar semantic-lex-c-preprocessor-symbol-map '())
(add-to-list 'semantic-lex-c-preprocessor-symbol-map '("Q_GUI_EXPORT" . ""))
(add-to-list 'semantic-lex-c-preprocessor-symbol-map '("Q_CORE_EXPORT" . ""))

(defun tserg/qt-mode-common-hook ()
  "Set up c-mode and related modes.
 Includes support for Qt code (signal, slots and alikes)."
  ;; (flyspell-prog-mode)
  (tserg/ac-qt-header-init)
  (tserg/set-ac-qt-clang-flags)
  ;; qt keywords and stuff ...
  ;; set up indenting correctly for new qt kewords
  (setq c-protection-key (concat "\\<\\(public\\|public slot\\|protected"
                                 "\\|protected slot\\|private\\|private slot"
                                 "\\)\\>")
        c-C++-access-key (concat "\\<\\(signals\\|public\\|protected\\|private"
                                 "\\|public slots\\|protected slots\\|private slots"
                                 "\\)\\>[ \t]*:"))
  (progn
    ;; modify the colour of slots to match public, private, etc ...
    (font-lock-add-keywords 'c++-mode
                            '(("\\<\\(slots\\|signals\\)\\>" . font-lock-type-face)))
    ;; make new font for rest of qt keywords
    (make-face 'qt-keywords-face)
    ;; (set-face-foreground 'qt-keywords-face "BlueViolet")
    (set-face-foreground 'qt-keywords-face "#d00db7")
    ;; qt keywords
    (font-lock-add-keywords 'c++-mode
                            '(("\\<Q_OBJECT\\|Q_UNUSED\\|Q_PROPERTY\\|Q_DECLARE_METATYPE\\>" . 'qt-keywords-face)))
    (font-lock-add-keywords 'c++-mode
                            '(("\\<SIGNAL\\|SLOT\\|QFETCH\\|QCOMPARE\\|QVERIFY\\>" . 'qt-keywords-face)))
    ;; (font-lock-add-keywords 'c++-mode
    ;;                         '(("\\<Q[A-Z][A-Za-z]*" . 'qt-keywords-face)))
    ))

;; (add-hook 'c-mode-common-hook 'tserg/ac-qt-header-init)
;; (add-hook 'c-mode-common-hook 'tserg/set-ac-qt-clang-flags)
(add-hook 'c-mode-common-hook 'tserg/qt-mode-common-hook)
