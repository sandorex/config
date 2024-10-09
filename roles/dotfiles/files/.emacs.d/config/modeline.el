;; simplistic modeline

(set-face-attribute 'mode-line-highlight nil
                    :foreground "#7A4491"
                    :background "white")

;; set modeline face
(set-face-attribute 'mode-line nil
                    :box nil
                    :foreground "white"
                    :background "#712E8E")
(set-face-attribute 'mode-line-inactive nil
                    :box nil
                    :foreground "#888888e"
                    :background "#712E8E")

(setq-default mode-line-format
              '("%e"
                (:eval (propertize (format " %s " (concat
                                                   ;; show @ when remote
                                                   (when (file-remote-p default-directory) "@ ")
                                                   (buffer-name)
                                                   ;; show * when modified
                                                   (if (buffer-modified-p) "*")
                                                   ))
                                   'face '(:background "#7A4491")
                                   'help-echo (buffer-file-name)))

                ;; readonly marker
                (:eval (if buffer-read-only " [RO]"))

                ;; overwrite mode marker
                (:eval (if overwrite-mode (propertize " [Ow]" 'face '(:foreground "red" :bold t))))
                
                ;; show major mode
                " "
                (:eval (propertize (capitalize (symbol-name major-mode)) 'face '(:bold t)))

                ;; show line and column 
                " / %l:%c"
                ))
