;; contains configuration for compilation mode

;; set compile-command for rust
(add-hook 'rust-ts-mode-hook (setq-local compile-command "cargo build"))

;; focus compilation-mode buffer on compile/recompile
(defadvice compile (after jump-back activate) (other-window 1))
(defadvice recompile (after jump-back activate) (other-window 1))

;; set everything up only when compile loads
(eval-after-load 'compile
  (lambda ()
    ;; scroll with compilation but stop at first error
    (setopt compilation-scroll-output 'first-error)

    ;; parse cargo warnings and errors in compilation mode
    (add-to-list 'compilation-error-regexp-alist 'cargo)

    ;; TODO properly set whether its a warning or error
    (add-to-list 'compilation-error-regexp-alist-alist
		 '(cargo . ("\\(?:error\\|warning\\): .+\n.*--> \\(.+\\):\\([0-9]+\\):\\([0-9]+\\)" 1 2 3 2 1)))

    (defun compilation-mode--user-setup ()
      "User setup of compilation mode"
      (setq proj (project-current nil))
      (when proj
	;; add project root to compilation search path for better experience
	(add-to-list 'compilation-search-path (project-root proj))))

    (add-hook 'compilation-mode-hook 'compilation-mode--user-setup)))
