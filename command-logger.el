;;; command-logger.el --- 実行したコマンドのログをとるやつ

;; Copyright (C) 2021 by Yuta Fujita

;; Author: Yuta Fujita <ofnhwx@komunan.net>
;; URL: https://github.com/ofnhwx/command-logger
;; Version: 0.01

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(eval-and-compile
  (require 'komunan-lisp-library)
  (require 's))

(defun command-logger--output (fn message)
  (kllib:propertize-message "[%s] %s" (propertize fn 'font-lock-face '(:foreground "#00bfff")) message))

(defun command-logger--start-process (name buffer program &rest args)
  (command-logger--output "start-process" (format "%s %s" program (s-join " " args))))

(defun command-logger--call-process (program &optional infile destination display &rest args)
  (command-logger--output "call-process" (format "%s %s" program (s-join " " args))))

;;;###autoload
(defun command-logger-on ()
  (interactive)
  (advice-add 'start-process :before #'command-logger--start-process)
  (advice-add 'call-process  :before #'command-logger--call-process))

;;;###autoload
(defun command-logger-off ()
  (interactive)
  (advice-remove 'start-process #'command-logger--start-process)
  (advice-remove 'call-process  #'command-logger--call-process))

(provide 'command-logger)
