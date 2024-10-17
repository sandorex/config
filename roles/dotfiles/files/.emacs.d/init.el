;; Minimal Configuration

(when (< emacs-major-version 29)
  (error "Oldest supported Emacs version is 29, you are on %s" emacs-major-version))

(require 'use-package)

;; load from user directory whatever it may be
(add-to-list 'load-path (concat user-emacs-directory "config/"))

;; i do not use third-party themes
;; (setopt custom-theme-directory (concat user-emacs-directory "themes/"))
;; (add-to-list 'load-path custom-theme-directory)

(setopt modus-themes-fringes 'subtle
        modus-themes-subtle-line-numbers t
        modus-themes-vivendi-color-overrides '((bg-main . "#010101")))

;; load machine specific custom file
(setopt custom-file (concat user-emacs-directory "config/custom-" (system-name) ".el"))
(load custom-file 'noerror 'nomessage)

;; load default theme if no themes are enabled
(unless custom-enabled-themes
  (load-theme 'modus-vivendi))

;; set backup in tmp so its available if needed but deleted often for security
(setopt backup-directory-alist '(("." . "/tmp/emacs-bak/")))

;;; extra files (for better readability) ;;;
(load "editor" nil 'nomessage)
(load "theming" nil 'nomessage)
(load "keys" nil 'nomessage)

;;; plugins (builtin) ;;;
(use-package compile
  :config
  ;; focus compilation-mode buffer on compile/recompile
  (defadvice compile (after jump-back activate)
    (unless (string= (buffer-name) "*compilation*")
      (other-window 1)))
  (defadvice recompile (after jump-back activate)
    (unless (string= (buffer-name) "*compilation*")
      (other-window 1)))

  ;; scroll with compilation but stop at first error
  (setopt compilation-scroll-output 'first-error)

  ;; cargo ;;
  (add-to-list 'compilation-error-regexp-alist 'cargo)
  (add-to-list 'compilation-error-regexp-alist-alist
	       '(cargo . ("\\(?:error\\|warning\\)\\(?:\\[.+\\]\\)?: .+\n *--> \\(.+\\):\\([0-9]+\\):\\([0-9]+\\)" 1 2 3 2 1))))

; TODO enable only if rust-analyzer is present
;(use-package eglot
;  :ensure t
;  :defer t
;  :hook (rust-ts-mode . eglot-ensure))

(use-package eldoc
  :init
  ;; less distracting eldoc, limit to single line
  (setopt eldoc-echo-area-display-truncation-message nil
          eldoc-echo-area-prefer-doc-buffer t ; prefer eldoc window if it exists
          eldoc-echo-area-use-multiline-p nil))

(use-package treesit
  :init
  ;; use treesitter rust mode
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
  :config
  ;; TODO install these automatically
  (setopt treesit-language-source-alist
          '((bash "https://github.com/tree-sitter/tree-sitter-bash")
            (rust "https://github.com/tree-sitter/tree-sitter-rust")
            (cmake "https://github.com/uyha/tree-sitter-cmake")
            (css "https://github.com/tree-sitter/tree-sitter-css")
            (elisp "https://github.com/Wilfred/tree-sitter-elisp")
            (go "https://github.com/tree-sitter/tree-sitter-go")
            (html "https://github.com/tree-sitter/tree-sitter-html")
            (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
            (json "https://github.com/tree-sitter/tree-sitter-json")
            (make "https://github.com/alemuller/tree-sitter-make")
            (markdown "https://github.com/ikatyang/tree-sitter-markdown")
            (python "https://github.com/tree-sitter/tree-sitter-python")
            (toml "https://github.com/tree-sitter/tree-sitter-toml")
            (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
            (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
            (yaml "https://github.com/ikatyang/tree-sitter-yaml"))))

(use-package eglot
  :config
  (setopt eglot-autoshutdown t              ; shutdown lsp server automatically
          eglot-send-changes-idle-time 0.1) ; faster update time

  ;; improves performance? (stolen from internet)
  (fset #'jsonrpc--log-event #'ignore))

;;; plugins (third-party) ;;;
;; TODO add corfu git submodule
;; (use-package corfu
;;   :load-path "site-lisp/ess/lisp/"
;;   :commands R)

;; reset gc-cons-threshold
(setq gc-cons-threshold (or emacs--initial-gc-threshold 800000))
