;; all keybindings and related

;;; keybindings ;;;
;; terminal does not support C-; also i keep hitting ; instead of C-;
(keymap-global-set "C-x ;" 'comment-line)

(keymap-global-set "C-c C-c" 'complete-symbol)

(keymap-global-set "<f7>" 'theme-choose-variant) ; toggle variant easily

(global-set-key [remap list-buffers] 'ibuffer) ; simply better

;; make C-x o sticky until other key is pressed
(defun user--other-window-sticky (count &optional all-frames)
  (interactive "p")
  (set-transient-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd "o") 'other-window) map)
   t)
  (other-window count all-frames))

(keymap-global-set "C-x o" 'user--other-window-sticky)

(defun zoom-window ()
  "Zoom in the current window saving the frame layout and deleting other windows"
  (interactive)
  (if (not (get-register 'zoom))
      ;; no register meaning not zoomed
      (unless (one-window-p) ; nothing to do if single window
        (window-configuration-to-register 'zoom)
        (delete-other-windows))
    ;; there is a register to restore
    (progn
      (point-to-register 'zoom-bak) ; save current window
      (jump-to-register 'zoom)      ; restore whole frame
      (register-to-point 'zoom-bak) ; restore current window

      ;; delete both registers
      (set-register 'zoom-bak nil)
      (set-register 'zoom nil))))

(keymap-global-set "C-x z" 'zoom-window)

;; move line up
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (previous-line 2))

(keymap-global-set "C-S-<up>" 'move-line-up)

;; move line down
(defun move-line-down ()
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))

(keymap-global-set "C-S-<down>" 'move-line-down)
