;; contains configuration for compilation mode

;; (add-hook 'rust-ts-mode-hook
;;           (lambda ()
;;             (setq-local compile-command "cargo build ")))

;; set everything up only when compile loads
(eval-after-load 'compile
  (lambda ()
    ;; focus compilation-mode buffer on compile/recompile
    (defadvice compile (after jump-back activate)
      (unless (string= (buffer-name) "*compilation*")
        (other-window 1)))
    (defadvice recompile (after jump-back activate)
      (unless (string= (buffer-name) "*compilation*")
        (other-window 1)))

    ;; scroll with compilation but stop at first error
    (setopt compilation-scroll-output 'first-error)

    ;; cargo ;;
    (add-to-list 'compilation-error-regexp-alist 'cargo)

    ;; TODO properly set whether its a warning or error
    (add-to-list 'compilation-error-regexp-alist-alist
		 '(cargo . ("\\(?:error\\|warning\\).*: .+\n.*--> \\(.+\\):\\([0-9]+\\):\\([0-9]+\\)" 1 2 3 2 1)))))
