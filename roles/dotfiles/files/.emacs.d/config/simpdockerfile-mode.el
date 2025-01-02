;;; simpdockerfile-mode.el --- Major mode for editing Docker's Dockerfiles -*- lexical-binding: t -*-
;; The package was slimmed down to only syntax and maybe few extra features

;; Copyright (c) 2013 Spotify AB
;; Package-Requires: ((emacs "24"))
;; Homepage: https://github.com/spotify/dockerfile-mode
;; URL: https://github.com/spotify/dockerfile-mode
;; Version: 1.7
;; Keywords: docker languages processes tools
;;
;; Licensed under the Apache License, Version 2.0 (the "License"); you may not
;; use this file except in compliance with the License. You may obtain a copy of
;; the License at
;;
;; http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
;; WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
;; License for the specific language governing permissions and limitations under
;; the License.

;;; Commentary:

;; Provides a major mode `dockerfile-mode' for use with the standard
;; `Dockerfile' file format.  Additional convenience functions allow
;; images to be built easily.

;;; Code:

(require 'sh-script)
(require 'rx)

(defgroup dockerfile nil
  "Dockerfile editing commands for Emacs."
  :link '(custom-group-link :tag "Font Lock Faces group" font-lock-faces)
  :prefix "dockerfile-"
  :group 'languages)

(defcustom dockerfile-enable-auto-indent t
  "Toggles the auto indentation functionality."
  :type 'boolean)

(defcustom dockerfile-indent-offset (or standard-indent 2)
  "Dockerfile number of columns for margin-changing functions to indent."
  :type 'integer
  :safe #'integerp
  :group 'dockerfile)

(defface dockerfile-image-name
  '((t (:inherit (font-lock-type-face bold))))
  "Face to highlight the base image name after FROM instruction.")

(defface dockerfile-image-alias
  '((t (:inherit (font-lock-constant-face bold))))
  "Face to highlight the base image alias inf FROM ... AS <alias> construct.")

(defconst dockerfile--from-regex
  (rx "from " (group (+? nonl)) (or " " eol) (? "as " (group (1+ nonl)))))

(defvar dockerfile-font-lock-keywords
  `(,(cons (rx (or line-start "onbuild ")
               (group (or "from" "maintainer" "run" "cmd" "expose" "env" "arg"
                          "add" "copy" "entrypoint" "volume" "user" "workdir" "onbuild"
                          "label" "stopsignal" "shell" "healthcheck"))
               word-boundary)
           font-lock-keyword-face)
    (,dockerfile--from-regex
     (1 'dockerfile-image-name)
     (2 'dockerfile-image-alias nil t))
    ,@(sh-font-lock-keywords)
    ,@(sh-font-lock-keywords-2)
    ,@(sh-font-lock-keywords-1))
  "Default `font-lock-keywords' for `dockerfile mode'.")

(defvar dockerfile-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?# "<" table)
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?' "\"" table)
    (modify-syntax-entry ?= "." table)
    table)
  "Syntax table for `dockerfile-mode'.")

(define-abbrev-table 'dockerfile-mode-abbrev-table nil
  "Abbrev table used while in `dockerfile-mode'.")

(unless dockerfile-mode-abbrev-table
  (define-abbrev-table 'dockerfile-mode-abbrev-table ()))

(defun dockerfile-indent-line-function ()
  "Indent lines in a Dockerfile.

Lines beginning with a keyword are ignored, and any others are
indented by one `dockerfile-indent-offset'. Functionality toggled
by `dockerfile-enable-auto-indent'."
  (when dockerfile-enable-auto-indent
    (unless (member (get-text-property (line-beginning-position) 'face)
             '(font-lock-comment-delimiter-face font-lock-keyword-face))
     (save-excursion
       (beginning-of-line)
       (unless (looking-at-p "\\s-*$") ; Ignore empty lines.
         (indent-line-to dockerfile-indent-offset))))))

(defun dockerfile--imenu-function ()
  "Find the previous headline from point.

Search for a FROM instruction.  If an alias is used this is
returned, otherwise the base image name is used."
  (when (re-search-backward dockerfile--from-regex nil t)
    (let ((data (match-data)))
      (when (match-string 2)
        ;; we drop the first match group because
        ;; imenu-generic-expression can only use one offset, so we
        ;; normalize to `1'.
        (set-match-data (list (nth 0 data) (nth 1 data) (nth 4 data) (nth 5 data))))
      t)))

;;;###autoload
(define-derived-mode dockerfile-mode prog-mode "Dockerfile"
  "A major mode to edit Dockerfiles.
\\{dockerfile-mode-map}"
  (set-syntax-table dockerfile-mode-syntax-table)
  (set (make-local-variable 'imenu-generic-expression)
       `(("Stage" dockerfile--imenu-function 1)))
  (set (make-local-variable 'require-final-newline) mode-require-final-newline)
  (set (make-local-variable 'comment-start) "#")
  (set (make-local-variable 'comment-end) "")
  (set (make-local-variable 'comment-start-skip) "#+ *")
  (set (make-local-variable 'parse-sexp-ignore-comments) t)
  (set (make-local-variable 'font-lock-defaults)
       '(dockerfile-font-lock-keywords nil t))
  (setq local-abbrev-table dockerfile-mode-abbrev-table)
  (set (make-local-variable 'indent-line-function) #'dockerfile-indent-line-function))

;;;###autoload
(add-to-list 'auto-mode-alist
             (cons (concat "[/\\]"
                           "\\(?:Containerfile\\|Dockerfile\\)"
                           "\\(?:\\.[^/\\]*\\)?\\'")
                   'dockerfile-mode))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.dockerfile\\'" . dockerfile-mode))

(provide 'simpdockerfile-mode)

;;; simpdockerfile-mode.el ends here
