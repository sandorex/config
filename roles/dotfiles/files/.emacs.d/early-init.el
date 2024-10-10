(setq emacs--initial-gc-threshold gc-cons-threshold)
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Silence stupid startup message
(setq inhibit-startup-echo-area-message (user-login-name))
(setq frame-resize-pixelwise t)

(tool-bar-mode -1)      ; remove toolbar
(menu-bar-mode -1)      ; remove menu bar

(setq default-frame-alist
      '((vertical-scroll-bars . nil)
        (horizontal-scroll-bars . nil)

        ;; bit larger size
        ;; TODO scale with font size
        (height . 30)
        (width . 90)

        ;; start with dark background so there is no flashbang
        (background-color . "#000000")
        (foreground-color . "#ffffff")

        ;; prevent flashes when theme loads
        (ns-appearance . dark)
        (ns-transparent-titlebar . t)))
