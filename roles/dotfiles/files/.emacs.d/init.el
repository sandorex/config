;;; init.el -- Minimal Configuration
;;;
;;; Commentary:
;;; Minimal configuration which uses the least third-party packages
;;;
;;; Code:

(when (< emacs-major-version 29)
  (error "Oldest supported Emacs version is 29, you are on %s" emacs-major-version))

(require 'use-package)

;; load from user directory whatever it may be
(add-to-list 'load-path (concat user-emacs-directory "config/"))
(setopt modus-themes-fringes 'subtle
        modus-themes-subtle-line-numbers t
        modus-themes-vivendi-color-overrides '((bg-main . "#010101"))

        custom-file (concat user-emacs-directory "config/custom-" (system-name) ".el")

        ;; disable backups
        make-backup-files nil)

;; load machine specific custom file
(load custom-file 'noerror 'nomessage)

;; load default theme if no themes are enabled
(unless custom-enabled-themes
  (load-theme 'modus-vivendi))

;;; other files ;;;
(load "theming" nil 'nomessage)

;; configure the editor itself
(use-package emacs
  :hook ((prog-mode . display-line-numbers-mode)
         ;;(prog-mode . whitespace-mode)
         (prog-mode . flymake-mode)

         (text-mode . visual-line-mode) ; nicer wrap when editing raw text

         (before-save . delete-trailing-whitespace))
  :custom
  (display-line-numbers-width 3) ; increase linenum column width to prevent movement while scrolling

  ;; whitespace
  (whitespace-line-column 80)
  (whitespace-style '(face lines-tail))
  (fill-column 80)

  ;; enter spaces not tabs
  (indent-tabs-mode nil)
  (sentence-end-double-space nil)

  (use-short-answers t)
  (confirm-kill-emacs 'yes-or-no-p)

  ;; redirect to link target when visting links
  (find-file-visit-truename t)
  (vc-follow-symlinks t)

  (tab-bar-show 1) ; show tab bar only if more than 1 tab

  ;; automaticall reload files on change
  (auto-revert-avoid-polling t)
  (auto-revert-interval 5)
  (auto-revert-check-vc-info t)
  (global-auto-revert-non-file-buffers t)

  (cursor-type 'bar) ; vertical line cursor, easier to select things

  ;; autocompletion tweaks
  (completions-group t)
  (completions-detailed t)
  (completions-max-height 16)
  (completions-sort nil)
  (completions-format 'one-column)
  (completion-auto-select 'second-tab) ; autofocus comp buffer on second press of tab
  (completion-styles '(basic flex partial-completion emacs22))
  (tab-always-indent 'complete) ; complete or indent on tab

  ;; more vim-like scrolling without jumping whole page and centering cursor
  (scroll-margin 2)
  (scroll-conservatively 101)
  (scroll-up-aggressively 0.01)
  (scroll-down-aggressively 0.01)

  (history-length 25)       ; minibuffer history size
  (mark-ring-max 32)        ; mark buffer size
  (global-mark-ring-max 32)
  (set-mark-command-repeat-pop t)

  :init
  (show-paren-mode 1)         ; highlight matching parentheses
  (winner-mode 1)             ; quickly restore windows
  (global-auto-revert-mode 1) ; reload buffers automatically
  (cua-selection-mode 1)      ; allows C-RET selection / multi cursor / replace yank
  (fido-mode 1)               ; autocompletion in minibuffer
  (fido-vertical-mode 1)
  (xterm-mouse-mode 1)        ; enable mouse in terminal
  (blink-cursor-mode -1)      ; disable blinking cursor
  (savehist-mode 1)           ; keep minibuffer command history
  (global-so-long-mode 1)     ; do not hang on long files
  (context-menu-mode 1)       ; enable context menu with mouse (works in terminal too)

  ;; enable narrow-to-region
  (put 'narrow-to-region 'disabled nil))

;;; non-plugin keybindings ;;;
(keymap-global-set "C-c x r" 'restart-emacs)
(keymap-global-set "C-x ;" 'comment-line) ; C-; not supported in terminal
(keymap-global-set "C-c d" 'duplicate-line)

(keymap-global-set "<f7>" 'theme-choose-variant) ; toggle light/dark theme

(global-set-key [remap list-buffers] 'ibuffer) ; simply better

;; make C-x o sticky until other key is pressed
(defun user--other-window-sticky (count &optional all-frames)
  (interactive "p")
  (set-transient-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd "o") 'other-window) map)
   t)
  (other-window count all-frames))

(keymap-global-set "C-x o" 'user--other-window-sticky)

(defun zoom-window ()
  "Zoom in the current window saving the frame layout and deleting other windows"
  (interactive)
  (if (not (get-register 'zoom))
      ;; no register meaning not zoomed
      (unless (one-window-p) ; nothing to do if single window
        (window-configuration-to-register 'zoom)
        (delete-other-windows))
    ;; there is a register to restore
    (progn
      (point-to-register 'zoom-bak) ; save current window
      (jump-to-register 'zoom)      ; restore whole frame
      (register-to-point 'zoom-bak) ; restore current window

      ;; delete both registers
      (set-register 'zoom-bak nil)
      (set-register 'zoom nil))))

(keymap-global-set "C-x z" 'zoom-window)

;; TODO make it work with multiple lines
;; ;; move line up
;; (defun move-line-up ()
;;   (interactive)
;;   (transpose-lines 1)
;;   (previous-line 2))

;; (keymap-global-set "C-S-<up>" 'move-line-up)

;; ;; move line down
;; (defun move-line-down ()
;;   (interactive)
;;   (next-line 1)
;;   (transpose-lines 1)
;;   (previous-line 1))

;; (keymap-global-set "C-S-<down>" 'move-line-down)

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

(use-package dired
  :custom
  ;; do not show owner
  ;; add size suffix for each file
  ;; show links
  (dired-listing-switches "-alFhgob"))

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

(use-package flymake
  :bind (:map flymake-mode-map
              ("C-c n" . flymake-goto-next-error)
              ("C-c p" . flymake-goto-prev-error)
              ("C-c b" . flymake-show-buffer-diagnostics)))

;;; plugins (third-party) ;;;

;; reset gc-cons-threshold
(setopt gc-cons-threshold (or emacs--initial-gc-threshold 800000))

(provide 'init)
;;; init.el ends here
