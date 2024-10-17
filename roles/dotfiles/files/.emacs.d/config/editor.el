;; contains all editor configuration

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3) ; Set a minimum width

(add-hook 'prog-mode-hook 'whitespace-mode)
(setopt whitespace-line-column 80
        whitespace-style '(face lines-tail)
        fill-column 80)

(add-hook 'prog-mode-hook #'flymake-mode)

;; nicer wrap when editing text
(add-hook 'text-mode-hook 'visual-line-mode)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setopt use-short-answers t)
(setopt confirm-kill-emacs 'yes-or-no-p)

;; redirect to link target when visting links
(setopt find-file-visit-truename t)
(setopt vc-follow-symlinks t)

;; show tab bar only if more than 1 tab
(setopt tab-bar-show 1)

(show-paren-mode 1)

(winner-mode 1) ; quickly restore windows

(setopt auto-revert-avoid-polling t)
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(setopt global-auto-revert-non-file-buffers t) ; reload dired buffers automatically
(global-auto-revert-mode 1) ; reload buffers automatically

(cua-selection-mode 1) ; allows C-RET selection / multi cursor

(fido-mode 1)
(fido-vertical-mode 1)

(xterm-mouse-mode 1)      ; enable mouse in terminal
(blink-cursor-mode -1)    ; disable blinking cursor
(setopt cursor-type 'bar) ; vertical line cursor to better show what is actually selected, also default in some terminals

(setopt history-length 20) ; save queries in minibuffer
(savehist-mode 1)

(global-so-long-mode t) ; do not hang on long files

;; disabled as it is a pain in the ass to close
;; (setopt enable-recursive-minibuffers t)                ; Use the minibuffer whilst in the minibuffer

;; NOTE i commented these out as they often get in the way i do not want such
;; distracting autocompletion, i mapped the completion to C-c C-c
;;
;; ill go through these some other time
;; (setopt completion-cycle-threshold 1)                  ; TAB cycles candidates
;; (setopt completions-detailed t)                        ; Show annotations

;; (setopt completion-styles '(basic initials substring)) ; Different styles to match input to candidates

;; (setopt completion-auto-help 'always)                  ; Open completion always; `lazy' another option
;; (setopt completions-max-height 20)                     ; This is arbitrary
;; (setopt completions-detailed t)
;; (setopt completions-format 'one-column)
;; (setopt completions-group t)
;; (setopt completion-auto-select 'second-tab)            ; Much more eager

(setopt completions-group t
        completions-detailed t
        completions-max-height 16
        completion-auto-select 'second-tab ; autofocus comp buffer on second tab
        tab-always-indent 'complete)       ; complete on indent on tab

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete) ; TAB acts more like how it does in the shell

; more vim-like scrolling without jumping whole page and centering cursor
(setopt scroll-margin 2
        scroll-conservatively 101
        scroll-up-aggressively 0.01
        scroll-down-aggressively 0.01)

(setopt indent-tabs-mode nil) ; do not enter tabs randomly.. wtf
(setopt sentence-end-double-space nil)

(setopt show-trailing-whitespace t) ; highlight trailling whitespace

;; context menu mode in GUI only
(when (display-graphic-p)
  (context-menu-mode))

(setopt mark-ring-max 32)
(setopt global-mark-ring-max 32)

(setopt set-mark-command-repeat-pop t)

; seems like a cool feature
(put 'narrow-to-region 'disabled nil)
