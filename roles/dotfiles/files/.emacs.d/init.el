;; Minimal Configuration
;;
;; Using: eglot project.el

;; load from user directory whatever it may be
(add-to-list 'load-path (concat user-emacs-directory "config"))

;; load machine specific custom file
(setq custom-file (concat "custom-" (system-name) ".el"))
(load custom-file 'noerror 'nomessage)

;; disable the startup message
(defun display-startup-echo-area-message ())

;; set backup in tmp so its available if needed but deleted often for security
(setq-default backup-directory-alist '(("." . "/tmp/emacs-bak")))

;; start with appropriate size
(add-to-list 'default-frame-alist '(height . 30))
(add-to-list 'default-frame-alist '(width . 90))

(unless (display-graphic-p)
  ;; fix some keys in terminal (has to be set in terminal explicitly)
  ;; NOTE keymap-set does not work here
  (define-key key-translation-map (kbd "\e[[;") (kbd "C-;")))

;; keybindings (currently too short for separate file)
(keymap-global-set "<f9>" 'recompile)

(eval-after-load 'compile (load "compile-mode.el"))
(load "editor.el")
(load "modeline.el")
(load "lsp.el")
