;;; Code:
;; TODO make it ask for file and default to the emacs-abbrevs
(defun load-safe-abbrevs (&optional file)
  "Read safe abbrevs file (either FILE or emacs-abbrevs in `default-directory')."
  (interactive)
  (message "Loading safe abbreviations..")
  ;; initiate the abbrev table or clear old one
  (if 'safe-abbrevs-abbrev-table
      (define-abbrev-table 'safe-abbrevs-abbrev-table '() "Safe literal string expansion abbreviations, used for temporary abbrevs")
    (clear-abbrev-table safe-abbrevs-abbrev-table))
  ;; iterate over the file with temp buffer
  (with-temp-buffer
    (insert-file-contents (or file (concat default-directory "emacs-abbrevs")))
    (goto-char (point-min))
    (while (not (eobp))
      (let ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
        (unless (string-prefix-p ";" line)
          (when-let ((split (string-split line "|" 'omit))
                (key (nth 0 split))
                (val (nth 1 split)))
            ;; :system is important so they are not saved
            (define-abbrev safe-abbrevs-abbrev-table key val nil :system t))))
      ;; go to the next line
      (forward-line 1))))

;; i do not even need writer mode if the abbrevs are safe
;; (define-minor-mode writer-mode
;;   "Enables features for writing stories, books etc."
;;   :init-value nil ; disabled by default
;;   :group 'dotfiles
;;   :lighter " writer"
;;   ;; :keymap
;;   ;; (list (cons (kbd "C-c t")
;;   ;;             (lambda ()
;;   ;;               (interactive)
;;   ;;               (message "pressed it hah!"))))

;;   (if writer-mode
;;       (progn
;;         (message "Writer mode enabled")
;;         (define-abbrev-table 'writer-mode-abbrev-table '() "Abbreviations for writer mode"))
;;     (message "Writer mode disabled")))

;; (add-hook 'writer-mode-on-hook
;;           (lambda ()
;;             ;; enable abbrev mode
;;             (abbrev-mode 1)))

(provide 'writer-mode)
;;; writer-mode.el ends here
