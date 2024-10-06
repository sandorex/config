(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(package-initialize)

(tool-bar-mode 0)      ; remove toolbar
(menu-bar-mode 0)      ; remove menu bar
(global-display-line-numbers-mode 1)
(show-paren-mode 1)

(ido-mode 1)             ; autocompletion?
(ido-everywhere 1)
;(ido-ubiquitous-mode 1)

(xterm-mouse-mode 1)     ; enable mouse in terminal

(setq-default indent-tabs-mode nil) ; do not enter tabs randomly.. wtf


