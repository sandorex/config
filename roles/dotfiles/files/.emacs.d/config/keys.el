;; all keybindings and related

(keymap-global-set "<f9>" 'recompile)

;; make C-x o stick until other key is pressed
(defun other-window-and-beyond (count &optional all-frames)
  (interactive "p")
  (set-transient-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd "o") 'other-window) map)
   t)
  (other-window count all-frames))

(keymap-global-set "C-x o" 'other-window-and-beyond)
