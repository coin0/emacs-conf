;;(load-file "/Applications/Emacs.app/Contents/Resources/site-lisp/php-mode.el")
;;(require 'php-mode)

;; modern C++11
(add-to-list 'load-path "/home/linq/.emacs.d/cpp11")
(require 'modern-cpp-font-lock)
(modern-c++-font-lock-global-mode t)

;; cscope
(load-file "/home/linq/.emacs.d/cscope/xcscope.el")

(add-to-list 'load-path "/Users/linxiansheng/.emacs.d/go-mode/")
;(require 'go-mode-autoloads)
;(require 'go-autocomplete)
;(require 'auto-complete-config)
;;(ac-config-default)
(autoload 'go-mode "go-mode" nil t)

(setq c-default-style "linux")
(defun my-c-mode-hook ()
  (setq indent-tabs-mode t)
  (setq tab-width 2))
(add-hook 'c-mode-hook 'my-c-mode-hook)

;; java mode
(add-hook 'java-mode-hook (lambda ()
                            (setq c-basic-offset 4 ;; indent
                                  tab-width 4      ;; tab indent
                                  indent-tabs-mode nil))) ;; tab => spaces

;; javascript mode
(setq js-indent-level 4) ;; indent spaces

;; google C++11 style
;(add-to-list 'load-path "/home/linq/.emacs.d/google-style") 
;(require 'google-c-style)
;(add-hook 'c-mode-common-hook 'google-set-c-style) 
;(add-hook 'c-mode-common-hook 'google-make-newline-indent) 

(global-set-key [(control h)] 'backward-delete-char-untabify)

(global-set-key [(f2)] 'split-window-vertically)
(global-set-key [(f3)] 'split-window-horizontally)
(global-set-key [(f4)] 'delete-window)
(global-set-key [(f5)] 'other-window)
(global-set-key [(f6)] 'shell)
(global-set-key [(f7)] 'highlight-phrase)

;;(global-set-key "\r" 'align-newline-and-indent) ;;对齐+换行+缩进
(global-set-key "\r" 'newline-and-indent) ;;换行+缩进

;;(set-frame-font "-H&Co-Gotham-light-normal-normal-*-*-*-*-*-*-0-iso10646-1") ;;默认字体大小设置
;;(add-to-list 'default-frame-alist '(font . "FreeMono-12"))

;;Coin的默认颜色
(setq initial-frame-alist '(
			    (mouse-color . "midnightblue")
			    (foreground-color . "grey20")
			    (background-color . "alice blue")
                            ))

;; disable startup
(setq-default inhibit-startup-message t)

;; remove toolbar
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; replace TAB with SPACE
(setq-default indent-tabs-mode nil)

;; default working directory
(setq-default default-directory "~")

;; show time of day
(display-time)

;; show line number
(column-number-mode t)

;; highlight parenthesis pair
(show-paren-mode t)

;; no buzz
(setq-default visible-bell t)

;; answer by y or n
(fset 'yes-or-no-p 'y-or-n-p)

;; scroll steadly
(setq-default scroll-margin 3 scroll-conservatively 10000)

;; highlight current line
(global-hl-line-mode 1)

;; never generate backup files
(setq-default make-backup-files nil)

;; close autosave
(setq-default auto-save-mode nil)

;; never generate #filename#
(setq-default auto-save-default nil)

;;
;; customized functions
;;

;; ##### move line up or down #####
(global-set-key [(meta p)] 'move-line-up)
(global-set-key [(meta n)] 'move-line-down)

(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

;;######### exit shell buffer if finished #############
(add-hook 'shell-mode-hook 'wcy-shell-mode-hook-func)

(defun wcy-shell-mode-hook-func ()
  (set-process-sentinel (get-buffer-process (current-buffer))
                        #'wcy-shell-mode-kill-buffer-on-exit)
  )

(defun wcy-shell-mode-kill-buffer-on-exit (process state)
  (message "%s" state)
  (if (or
       (string-match "exited abnormally with code.*" state)
       (string-match "finished" state))
      (kill-buffer (current-buffer))))

;;####### enter fullscreen mode #########
(global-set-key [(f8)] 'fullscreen)

(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
                       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))

;;####### melpa #########
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(go-mode htmlize xcscope actionscript-mode auto-complete)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; ###### kill backward spaces #####
(global-set-key [(meta h)] 'xah-shrink-whitespaces)

(defun xah-delete-blank-lines ()
  "Delete all newline around cursor.

URL `http://ergoemacs.org/emacs/emacs_shrink_whitespace.html'
Version 2018-04-02"
  (interactive)
  (let ($p3 $p4)
          (skip-chars-backward "\n")
          (setq $p3 (point))
          (skip-chars-forward "\n")
          (setq $p4 (point))
          (delete-region $p3 $p4)))

(defun xah-shrink-whitespaces ()
  "Remove whitespaces around cursor to just one, or none.

Shrink any neighboring space tab newline characters to 1 or none.
If cursor neighbor has space/tab, toggle between 1 or 0 space.
If cursor neighbor are newline, shrink them to just 1.
If already has just 1 whitespace, delete it.

URL `http://ergoemacs.org/emacs/emacs_shrink_whitespace.html'
Version 2018-04-02T14:38:04-07:00"
  (interactive)
  (let* (
         ($eol-count 0)
         ($p0 (point))
         $p1 ; whitespace begin
         $p2 ; whitespace end
         ($charBefore (char-before))
         ($charAfter (char-after ))
         ($space-neighbor-p (or (eq $charBefore 32) (eq $charBefore 9) (eq $charAfter 32) (eq $charAfter 9)))
         $just-1-space-p
         )
    (skip-chars-backward " \n\t")
    (setq $p1 (point))
    (goto-char $p0)
    (skip-chars-forward " \n\t")
    (setq $p2 (point))
    (goto-char $p1)
    (while (search-forward "\n" $p2 t )
      (setq $eol-count (1+ $eol-count)))
    (setq $just-1-space-p (eq (- $p2 $p1) 1))
    (goto-char $p0)
    (cond
     ((eq $eol-count 0)
      (if $just-1-space-p
          (delete-horizontal-space)
        (progn (delete-horizontal-space)
               (insert " "))))
     ((eq $eol-count 1)
      (if $space-neighbor-p
          (delete-horizontal-space)
        (progn (xah-delete-blank-lines) (insert " "))))
     ((eq $eol-count 2)
      (if $space-neighbor-p
          (delete-horizontal-space)
        (progn
          (xah-delete-blank-lines)
          (insert "\n"))))
     ((> $eol-count 2)
      (if $space-neighbor-p
          (delete-horizontal-space)
        (progn
          (goto-char $p2)
          (search-backward "\n" )
          (delete-region $p1 (point))
          (insert "\n"))))
     (t (progn
          (message "nothing done. logic error 40873. shouldn't reach here" ))))))
