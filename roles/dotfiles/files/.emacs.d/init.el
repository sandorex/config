(add-to-list 'load-path "~/.emacs.d/config")

;; load machine specific custom file
(setq custom-file (concat "custom-" (system-name) ".el"))
(load custom-file 'noerror 'nomessage)

;; disable the startup message
(defun display-startup-echo-area-message ())

;; move backup directory
(setq-default backup-directory-alist '(("~/.emacs.bak")))

;; start with appropriate size
(add-to-list 'default-frame-alist '(height . 30))
(add-to-list 'default-frame-alist '(width . 90))

(unless (display-graphic-p)
  (progn
    ;; fix some keys in terminal (has to be set in terminal explicitly)
    ;; NOTE keymap-set does not work here
    (define-key key-translation-map (kbd "\e[[;") (kbd "C-;"))
    ))

(eval-after-load 'compile (load "compile-mode.el"))
(load "editor.el")
(load "modeline.el")
(load "lsp.el")
