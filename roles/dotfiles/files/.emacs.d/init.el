;; Minimal Configuration

(when (< emacs-major-version 29)
  (error "Oldest supported emacs version is 29, you are on %s" emacs-major-version))

;; load from user directory whatever it may be
(add-to-list 'load-path (concat user-emacs-directory "config"))

;; load machine specific custom file
(setq custom-file (concat "custom-" (system-name) ".el"))
(load custom-file 'noerror 'nomessage)

;; set backup in tmp so its available if needed but deleted often for security
(setq-default backup-directory-alist '(("." . "/tmp/emacs-bak")))

;; start with appropriate size
(add-to-list 'default-frame-alist '(height . 30))
(add-to-list 'default-frame-alist '(width . 90))

(unless (display-graphic-p)
  ;; fix some keys in terminal (has to be set in terminal explicitly)
  ;; NOTE keymap-set does not work here
  (define-key key-translation-map (kbd "\e[[;") (kbd "C-;")))

(load "compile-mode" nil 'nomessage)
(load "editor" nil 'nomessage)
(load "modeline" nil 'nomessage)
(load "lsp" nil 'nomessage)
(load "keys" nil 'nomessage)

;; reset gc-cons-threshold
(setq gc-cons-threshold (or emacs--initial-gc-threshold 800000))
