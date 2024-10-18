;;; theming.el --- theming
;;; Commentary:
;;; Code:

;; set the modeline format
(setopt mode-line-format
        '("%e"
          (:eval (propertize (format " %s " (concat
                                             ;; show @ when remote
                                             (when (file-remote-p default-directory) "@ ")
                                             (buffer-name)
                                             ;; show * when modified
                                             (if (buffer-modified-p) "*")
                                             ))
                             'face '(:background "#8E46AE")
                             'help-echo (buffer-file-name)))

          ;; readonly marker
          (:eval (if buffer-read-only " [RO]"))

          ;; show if zoomed
          (:eval (when (get-register 'zoom) " [Z]"))

          ;; overwrite mode marker
          (:eval (if overwrite-mode (propertize " [Ow]" 'face '(:foreground "red" :bold t))))

          ;; show major mode
          " "
          (:eval (propertize (capitalize (symbol-name major-mode)) 'face '(:bold t)))

          ;; show line and column
          " (%l:%c)"
          ))

(defun user--modeline-update ()
  "Sets up colors which get overwritten by themes"
  (let ((bg-color "#712E8E"))
    (set-face-attribute 'minibuffer-prompt nil
                        :foreground "white"
                        :background bg-color)

    ;; not sure this is required at all
    (set-face-attribute 'mode-line-highlight nil
                        :foreground bg-color
                        :background "white")

    ;; set modeline face
    (set-face-attribute 'mode-line nil
                        :box nil
                        :foreground "white"
                        :background bg-color)
    (set-face-attribute 'mode-line-inactive nil
                        :box nil
                        :foreground "#888888e"
                        :background bg-color)))

;; call it once on setup
(user--modeline-update)

;; reload modeline after setting a theme as the theme overrides it..
(defadvice load-theme (after load-theme activate)
  (user--modeline-update))

(provide 'theming)
;;; theming.el ends here
