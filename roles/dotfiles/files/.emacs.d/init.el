;; path to the config dir (usually ~/.emacs.d)
(setq config-path (file-name-directory (locate-user-emacs-file "init.el")))

;; load machine specific custom file
(setq custom-file (concat config-path "custom-" (system-name) ".el"))
(load custom-file 'noerror 'nomessage)

;; allow loading themes from themes dir
(add-to-list 'custom-theme-load-path (concat config-path "themes/"))

;; move backup directory
(setq-default backup-directory-alist '(("~/.emacs.bak")))

(package-initialize)

(tool-bar-mode 0)      ; remove toolbar
(menu-bar-mode 0)      ; remove menu bar
(global-display-line-numbers-mode 1)
(show-paren-mode 1)

(global-auto-revert-mode 1) ; reload buffers automatically
(setq global-auto-revert-non-file-buffers t) ; reload dired buffers automatically

(cua-selection-mode 1) ; allows C-RET selection / multi cursor

(ido-mode 1)           ; autocompletion?
(ido-everywhere 1)

(xterm-mouse-mode 1)     ; enable mouse in terminal

(setq-default history-length 20) ; save queries in minibuffer
(savehist-mode 1)

; more vim-like scrolling without jumping whole page and centering cursor
(setq-default scroll-margin 2
              scroll-conservatively 101
              scroll-up-aggressively 0.01
              scroll-down-aggressively 0.01)

(setq-default indent-tabs-mode nil) ; do not enter tabs randomly.. wtf

; seems like a cool feature
(put 'narrow-to-region 'disabled nil)

; TODO get path to the emacs dir so there is no raw paths
(load (concat config-path "modeline.el"))
(load (concat config-path "lsp.el"))

