;;; twee-mode.el --- Basic syntax coloring for Twee files with Snowman 2.0 format -*- lexical-binding: t; -*-

;; Copyright (C) 2020 Ian McCowan

;; Author: Ian McCowan <ian@mccowan.space>
;; Version: 1.0
;; Package-Requires: ((emacs "26.1"))
;; Keywords: multimedia
;; URL: http://tilde.town/~cristo/twee-mode-for-emacs.html

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Simple syntax colors for Twee files with the Snowman 2.0 format.

;;; Code:


(add-to-list 'auto-mode-alist '("\\.tw\\'" . twee-mode))
(add-to-list 'auto-mode-alist '("\\.twee\\'" . twee-mode))

(defconst twee-font-lock-keywords
  `((,(rx line-start
          (group-n 1 "::" (one-or-more not-newline))
          (one-or-more whitespace)
          (group-n 2 "{" (one-or-more not-newline) "}"))
     (1 'markdown-header-face-1)
     (2 'markdown-inline-code-face))  ; ::Passage
    (,(rx "[["
          (group-n 1 (+? not-newline))
          (optional
           (or "|" "->")
           (group-n 2 (+? not-newline)))
          "]]")
     (1 'markdown-link-face) (2 'markdown-header-face-1))
    (,(rx "<<" (one-or-more not-newline) ">>") . 'markdown-comment-face)))

(defcustom twee-compile-command "tweego -f snowman-2"
  "Command used to compile Twee source.")

(defun twee-compile ()
  (interactive)
  (let ((out-file
         (concat
          (file-name-directory (buffer-file-name))
          (format "%s.html" (file-name-base (buffer-file-name))))))
    (compile (concat twee-compile-command
                     " "
                     (format "\"%s\"" (buffer-file-name))
                     " -o "
                     (format "\"%s\"" out-file)))
    (browse-url out-file)))

;;;###autoload
(define-derived-mode twee-mode markdown-mode "twee"
  "Twee mode for Twine stories."
  (font-lock-add-keywords nil twee-font-lock-keywords)
  (run-hooks 'twee-mode-hook))

(provide 'twee-mode)

;;; twee-mode.el ends here
