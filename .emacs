;;; XEmacs backwards compatibility file
(require 'package)
(require 'vc)
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

(add-to-list 'load-path "~/.emacs.d/nyan-mode/")
(load-file "~/.emacs.d/nyan-mode/nyan-mode.el")
(require 'nyan-mode)
(nyan-mode)

(package-initialize)

(setq user-init-file
      (expand-file-name "init.el"
			(expand-file-name ".xemacs" "~")))
(setq custom-file
      (expand-file-name "custom.el"
			(expand-file-name ".xemacs" "~")))
(setq custom-file
      (expand-file-name "pl.el"
			(expand-file-name ".xemacs" "~")))


(load-file user-init-file)
(load-file custom-file)

(cond ((eq system-type 'cygwin)
       (load "/usr/local/share/emacs/PLScript_mode.el")))
(cond ((eq system-type 'darwin)
       (load "~/.xemacs/PLScript_mode.el")))


;; Load MELPA Archives here
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)


;;=============================================================================
;; CUSTOM KEY BINDINGS
;;=============================================================================

;; disambiguate 'tab' from 'C-i' (which are the same in ASCII) by setting C-i to Hyper-i:
(keyboard-translate ?\C-i ?\H-i)
(global-set-key [?\H-i] 'indent-region)
(global-set-key (kbd "C-/") 'comment-region)
(global-set-key (kbd "C-?") 'uncomment-region)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-`") 'kill-this-buffer)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "<backtab>") 'dabbrev-expand)
(global-set-key (kbd "M-<up>") 'backward-paragraph)
(global-set-key (kbd "M-<down>") 'forward-paragraph)
(global-set-key (kbd "M-<left>") 'move-beginning-of-line)
(global-set-key (kbd "M-<right>") 'move-end-of-line)
(global-set-key (kbd "C-x C-q") 'vc-toggle-read-only)
(global-set-key (kbd "C-v") 'vc-diff)
(global-set-key (kbd "M-p") 'ace-window)
(define-key global-map (kbd "RET") 'newline-and-indent)
(global-set-key [?\C-'] 'hs-toggle-hiding)

;; ENABLE ESCAPE:
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; HIDE-SHOW BLOCKS
(global-set-key (kbd "C--") 'hs-hide-block)
(global-set-key (kbd "C-=") 'hs-show-block)

;; ;; begin windows-esque mapping:
;; (global-set-key (kbd "C-z") 'undo)
;; (global-set-key (kbd "C-w") 'kill-this-buffer)
;; (global-set-key (kbd "M-g") 'goto-line)
;; (global-set-key (kbd "C-s") 'save-buffer)
;; (global-set-key (kbd "C-c") 'copy-region-as-kill)
;; (global-set-key (kbd "\C-x") 'kill-region)
;; (global-set-key (kbd "C-v") 'yank)

;; SEARCH:
(global-set-key (kbd "C-f") 'isearch-forward)
(define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward) 
(define-key isearch-mode-map (kbd "C-r") 'isearch-repeat-backward) 

;; (progn
;;   (require 'dired )
;;   (define-key dired-mode-map (kbd "o") 'other-window)
;;   (define-key dired-mode-map (kbd "1") 'xah-previous-user-buffer)
;;   (define-key dired-mode-map (kbd "2") 'delete-window)
;;   (define-key dired-mode-map (kbd "3") 'delete-other-windows)
;;   (define-key dired-mode-map (kbd "4") 'split-window-below)
;;   (define-key dired-mode-map (kbd "C-o") 'find-file))


                                    
;;=============================================================================
;; MAKE ENVIRONMENT NICER
;;=============================================================================

;; CURSORS AND HIGHLIGHTING
(setq show-paren-delay 0)
(show-paren-mode 1)
(blink-cursor-mode nil)

;; WINDOW LOOK AND FEEL:
(custom-set-variables '(initial-frame-alist (quote ((fullscreen . maximized)))))
;; split vertical when opening more than one file:
(defun 2-windows-vertical-to-horizontal ()
  (let ((buffers (mapcar 'window-buffer (window-list))))
    (when (= 2 (length buffers))
      (delete-other-windows)
      (set-window-buffer (split-window-horizontally) (cadr buffers)))))
(add-hook 'emacs-startup-hook '2-windows-vertical-to-horizontal)
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
;;(global-linum-mode 1) ;;show line number column on left side of screen
;;(setq column-number-mode t)
(defun really-no-bell ()
"Do nothing so the bell won't ring even when emacs tries..."
   (interactive) )
(setq visible-bell nil)
(setq ring-bell-function 'really-no-bell)

;; GET YR SCROLL ON
(setq
  scroll-margin 7
  scroll-step 1
  scroll-conservatively 90
  scroll-preserve-screen-position 1
  mouse-wheel-progressive-speed nil
)
(cond ((eq system-type 'cygwin)
       (setq mouse-wheel-scroll-amount '(3))))
(cond ((eq system-type 'darwin)
       (setq mouse-wheel-scroll-amount '(7))))

;; LANGUAGE
(setq c-default-style "linux" c-basic-offset 4)
(setq-default c-C++-conditional-key "\\b\\(for\\|if\\|do\\|else\\|while\\|switch\\|try\\|catch\\|TRY\\|CATCH\\)\\b[^_]")

(if (>= (string-to-number (car (split-string emacs-version "\\."))) 23)
    (defun vc-toggle-read-only (&optional verbose)
      "Change read-only status of current buffer, perhaps via version control.
If the buffer is visiting a file registered with version control,
then check the file in or out.  Otherwise, just change the read-only flag
of the buffer.
With prefix argument, ask for version number to check in or check out.
Check-out of a specified version number does not lock the file;
to do that, use this command a second time with no argument."
      (interactive "P") 
      (if (vc-backend buffer-file-name) 
	  (vc-next-action nil)
	(toggle-read-only))))

;; THOSE ANNOYING EXTRA BUFFERS:
;; Makes *scratch* empty.
(setq initial-scratch-message "")

;; Removes *scratch* from buffer after the mode has been set.
(defun remove-scratch-buffer ()
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*")))
(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;; Removes *messages* from the buffer.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Removes *Completions* from buffer after you've opened a file.
(add-hook 'minibuffer-exit-hook
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
                (kill-buffer buffer)))))

;; Don't show *Buffer list* when opening multiple files at the same time.
;;(setq inhibit-startup-buffer-menu t)

;; No more typing the whole yes or no. Just y or n will do.
(fset 'yes-or-no-p 'y-or-n-p)

;; I hate it when you leave your messy backup files all over the goddamn floor, Paul.
(setq-default auto-save-default nil)
(setq-default make-backup-files nil)
(setq-default create-lockfiles nil)


;;=============================================================================
;; THEME AND APPEARANCE
;;=============================================================================

(add-to-list 'load-path "~/.emacs.d/themes/")
(load-file "~/.emacs.d/themes/santafe-theme.el")


(cond ((eq system-type 'darwin)
      (add-to-list 'default-frame-alist '(font . "Monofur-14"))))
(cond ((eq system-type 'cygwin)
      (add-to-list 'default-frame-alist '(font . "Monofur-10"))))

(setq-default line-spacing 3)




;;=============================================================================
;; ADDITIONAL PACKAGES:
;;=============================================================================

;; BOOKMARK+
;; (add-to-list 'load-path "~/.emacs.d/bookmark/")
;; (require 'bookmark+)
;;(setq bookmark-default-file

;; DESKTOP AID
;; (setq load-path (cons "~/.emacs.d/desktopaid/" load-path))
;; (autoload 'dta-hook-up "desktopaid.elc" "Desktop Aid" t)
;; (dta-hook-up)

;; DENNY'S WAY TO SAVE SESSIONS
;;; Automatically save and restore sessions
(setq desktop-dirname             "~/.emacs.d/desktop/"
      desktop-base-file-name      "emacs.desktop"
      desktop-base-lock-name      "lock"
      desktop-path                (list desktop-dirname)
      desktop-save                t
      desktop-load-locked-desktop nil)
 
(defun dsk ()
  "Load the desktop and enable autosaving"
  (interactive)
  (let ((desktop-load-locked-desktop "ask"))
    (font-lock-mode 1)
    (desktop-read)
    (desktop-save-mode 1)))
;;load using m-x my-desktop
;;rename my-desktop to whatever


;; Enable IDO buffer
(ido-mode 1)
(setq
  ido-enable-flex-matching t
  ido-everywhere t
  ido-ignore-buffers ;; Ignore these guys
  '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido" "^\*trace"
  "^\*compilation" "^\*GTAGS" "^session\.*" "^\*")
  ido-confirm-unique-completion t ;; wait for RET, even with unique completion
)



;; (add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))
;; (autoload 'jsx-mode "jsx-mode" "JSX mode" t)

;; ;; auto-complete mode
;; (add-to-list 'load-path "~/.emacs.d/auto-complete/")
;; (require 'auto-complete-lconfig)
;; ;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete//ac-dict")
;; (ac-config-default)
;; (add-to-list 'ac-modes 'plscript-mode)
;; (add-to-list 'ac-modes 'text-mode)
;; (setq ac-auto-show-menu .1)
;; (setq ac-disable-faces nil)


