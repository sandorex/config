(setq emacs--initial-gc-threshold gc-cons-threshold)
(setopt gc-cons-threshold 10000000
        warning-suppress-log-types '((comp) (bytecomp))
        native-comp-async-report-warnings-errors 'silent

        ;; prevent startup message
        inhibit-startup-echo-area-message (user-login-name)
        inhibit-startup-screen t
        frame-resize-pixelwise t)

(tool-bar-mode -1)      ; remove toolbar
(menu-bar-mode -1)      ; remove menu bar

(setopt default-frame-alist
        '((vertical-scroll-bars . nil)
          (horizontal-scroll-bars . nil)

          ;; default font override in custom-<host>.el
          (font . "Noto Sans Mono:pixelsize=16")

          ;; bit larger size
          (height . 30)
          (width . 90)

          ;; prevent flashes when theme loads
          (ns-appearance . dark)
          (ns-transparent-titlebar . t)))
