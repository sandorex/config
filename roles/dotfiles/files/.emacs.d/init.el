(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(package-initialize)

; use treesitter rust mode
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))

; TODO enable only if rust-analyzer is present
;(use-package eglot
;  :ensure t
;  :defer t
;  :hook (rust-ts-mode . eglot-ensure))

; shutdown server after killing last managed buffer
(setq eglot-autoshutdown t)

;; TODO install these automatically
(setq treesit-language-source-alist
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
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(tool-bar-mode 0)      ; remove toolbar
(menu-bar-mode 0)      ; remove menu bar
(global-display-line-numbers-mode 1)
(show-paren-mode 1)

(ido-mode 1)             ; autocompletion?
(ido-everywhere 1)

(xterm-mouse-mode 1)     ; enable mouse in terminal

; more vim-like scrolling without jumping whole page and centering cursor
(setq-default scroll-margin 2
              scroll-conservatively 101
              scroll-up-aggressively 0.01
              scroll-down-aggressively 0.01)

(setq-default indent-tabs-mode nil) ; do not enter tabs randomly.. wtf

; seems like a cool feature
(put 'narrow-to-region 'disabled nil)
