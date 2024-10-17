(setq emacs--initial-gc-threshold gc-cons-threshold)
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Silence stupid startup message
(setq inhibit-startup-echo-area-message (user-login-name))
(setq inhibit-startup-screen t)
(setq frame-resize-pixelwise t)

(tool-bar-mode -1)      ; remove toolbar
(menu-bar-mode -1)      ; remove menu bar

;; default theme
(load-theme 'leuven-dark t)

(setq default-frame-alist
      '((vertical-scroll-bars . nil)
        (horizontal-scroll-bars . nil)

        ;; default font override in custom-<host>.el
        (font . "Fira Code Nerd Font Mono:pixelsize=16")

        ;; bit larger size
        (height . 30)
        (width . 90)

        ;; prevent flashes when theme loads
        (ns-appearance . dark)
        (ns-transparent-titlebar . t)))
