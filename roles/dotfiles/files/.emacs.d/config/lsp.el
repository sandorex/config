;; general all lsp and language related things

; TODO enable only if rust-analyzer is present
;(use-package eglot
;  :ensure t
;  :defer t
;  :hook (rust-ts-mode . eglot-ensure))

;; use treesitter rust mode
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))

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
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(eval-after-load 'eglot
  (lambda ()
    (setopt eglot-autoshutdown t) ; shutdown lsp server automatically
    (setopt eglot-send-changes-idle-time 0.1) ; faster update time

    ;; improves performance? (stolen from internet)
    (fset #'jsonrpc--log-event #'ignore)))