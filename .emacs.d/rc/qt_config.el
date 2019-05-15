(defun tserg/qt-mode-common-hook ()
  "Set up c-mode and related modes.
 Includes support for Qt code (signal, slots and alikes)."

  ;; (flyspell-prog-mode)
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
                            '(("\\<SIGNAL\\|SLOT\\|QFETCH\\|QCOMPARE\\|QVERIFY\\|QTEST_MAIN\\>" . 'qt-keywords-face)))
    ;; (font-lock-add-keywords 'c++-mode
    ;;                         '(("\\<Q[A-Z][A-Za-z]*" . 'qt-keywords-face)))
    ))

(add-hook 'c-mode-common-hook 'tserg/qt-mode-common-hook)
