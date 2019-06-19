;; User pack init file
;;
;; Use this file to initiate the pack configuration.
;; See README for more information.

;; Load bindings config
(live-load-config-file "bindings.el")
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(global-set-key (kbd "s-3") '(lambda () (interactive) (insert "#")))

(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

(global-set-key [f7] 'toggle-fullscreen)


(remove-if (lambda (x)
             (eq 'font (car x)))
           default-frame-alist)
(cond
 ((and (window-system) (eq system-type 'darwin))
  (add-to-list 'default-frame-alist '(font . "Anonymous Pro 16"))))

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
                             "python -mjson.tool" (current-buffer) t)
    (esk-indent-buffer)))

(require 'nrepl)

(defun nrepl-limit-print-length ()
  (interactive)
  (nrepl-send-string-sync "(set! *print-length* 100)" "clojure.core"))

(defun nrepl-unlimit-print-length ()
  (interactive)
  (nrepl-send-string-sync "(set! *print-length* nil)" "clojure.core"))
