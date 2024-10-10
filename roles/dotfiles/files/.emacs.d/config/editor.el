;; contains all editor configuration

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3)           ; Set a minimum width

;; nicer wrap when editing text
(add-hook 'text-mode-hook 'visual-line-mode)

;; show tab bar only if more than 1 tab
(setopt tab-bar-show 1)

(show-paren-mode 1)
;;(winner-mode 1) ; easy window undo C-c <left>/<right>

(setopt auto-revert-avoid-polling t)
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(setopt global-auto-revert-non-file-buffers t) ; reload dired buffers automatically
(global-auto-revert-mode 1) ; reload buffers automatically

(cua-selection-mode 1) ; allows C-RET selection / multi cursor

(ido-mode 1)           ; autocompletion?
(ido-everywhere 1)

(xterm-mouse-mode 1)     ; enable mouse in terminal

(setopt history-length 20) ; save queries in minibuffer
(savehist-mode 1)

(setopt enable-recursive-minibuffers t)                ; Use the minibuffer whilst in the minibuffer
(setopt completion-cycle-threshold 1)                  ; TAB cycles candidates
(setopt completions-detailed t)                        ; Show annotations
(setopt tab-always-indent 'complete)                   ; When I hit TAB, try to complete, otherwise, indent
(setopt completion-styles '(basic initials substring)) ; Different styles to match input to candidates

(setopt completion-auto-help 'always)                  ; Open completion always; `lazy' another option
(setopt completions-max-height 20)                     ; This is arbitrary
(setopt completions-detailed t)
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completion-auto-select 'second-tab)            ; Much more eager

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete) ; TAB acts more like how it does in the shell

; more vim-like scrolling without jumping whole page and centering cursor
(setopt scroll-margin 2
        scroll-conservatively 101
        scroll-up-aggressively 0.01
        scroll-down-aggressively 0.01)

(setopt indent-tabs-mode nil) ; do not enter tabs randomly.. wtf
(setopt sentence-end-double-space nil)

(setopt show-trailing-whitespace t) ; highlight trailling whitespace

(setopt blink-cursor-mode 0) ; disable blinking cursor

(when (display-graphic-p)
  (context-menu-mode))

; seems like a cool feature
(put 'narrow-to-region 'disabled nil)
