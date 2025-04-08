;;; theming.el --- theming
;;; Commentary:
;;; Code:

(defun my/tab-bar-tab-name-format (tab i)
  "Custom tab name formatter (just adds padding before the tab index)"
  (let ((current-p (eq (car tab) 'current-tab)))
    (propertize
     (concat (if tab-bar-tab-hints (format " %d " i) " ")
             (alist-get 'name tab)
             (or (and tab-bar-close-button-show
                      (not (eq tab-bar-close-button-show
                               (if current-p 'non-selected 'selected)))
                      tab-bar-close-button)
                 ""))
     'face (funcall tab-bar-tab-face-function tab))))

(setq tab-bar-tab-name-format-function 'my/tab-bar-tab-name-format
        tab-bar-format '(
                         ;; show menu bar but use ASCII and with padding spaces
                         (lambda () '((menu-bar menu-item " @ " tab-bar-menu-bar :help "Menu Bar")))
                         tab-bar-format-tabs
                         (lambda () " ")) ; space makes the last tab not span till the end
        tab-bar-show 1 ; show tab bar only if more than 1 tab
        tab-bar-close-button-show nil
        tab-bar-new-tab-to 'rightmost
        tab-bar-tab-hints t
        tab-bar-separator "")

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

;; TODO make the buffer name background dimmer as well on when inactive
(defun user--modeline-update ()
  "Set up colors which get overwritten by themes."
  (let ((bg-color "#712E8E")
        (bg-color-inactive "#351344"))
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
                        :foreground "white"
                        :background bg-color-inactive)))

;; call it once on setup
(user--modeline-update)

;; reload modeline after setting a theme as the theme overrides it..
(defadvice load-theme (after load-theme activate)
  (user--modeline-update))

(provide 'theming)
;;; theming.el ends here
