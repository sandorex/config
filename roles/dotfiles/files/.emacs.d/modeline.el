;; simplistic modeline

;; TODO idk if these are required
;(setq mode-line-format nil)
;(kill-local-variable 'mode-line-format)
;(force-mode-line-update)

(setq-default mode-line-format
              '("%e"

                ; show buffer name
                (:eval (propertize (format " %s " (concat
                                                   (buffer-name)
                                                   (if (buffer-modified-p) "*")
                                                   )) 'face 'my-modeline-background))
                (:eval (if buffer-read-only " [RO]"))

                ; TODO idk what it does
                (:eval (when (file-remote-p default-directory)
                          (propertize "%1@"
                                      'mouse-face 'mode-line-highlight
                                      'help-echo (concat "remote: " default-directory))))

                ; show major mode
                " "
                (:eval (propertize (capitalize (symbol-name major-mode)) 'face 'bold))
                ))

(defface my-modeline-background
  '((t :background "#3355bb" :foreground "white" :inherit bold))
  "Face with a red background for use on the mode line.")

