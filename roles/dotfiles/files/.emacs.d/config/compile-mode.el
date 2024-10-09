;; contains configuration for compilation mode

(require 'compile)

;; parse cargo warnings and errors in compilation mode
(add-to-list 'compilation-error-regexp-alist 'cargo)
(add-to-list 'compilation-error-regexp-alist-alist
             '(cargo . ("\\(?:error\\|warning\\): .+\n.*--> \\(.+\\):\\([0-9]+\\):\\([0-9]+\\)" 1 2 3 2 1)))

;; scroll with compilation but stop at first error
(setq-default compilation-scroll-output 'first-error)
