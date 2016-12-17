(cond ((eq system-type 'cygwin)
       (load "/usr/local/share/emacs/PLScript_mode.el")
       (global-set-key (kbd "C-x t") 'plscript-insert-tag)
       (global-set-key (kbd "C-x m") 'plscript-insert-make)
       (global-set-key (kbd "C-x p") 'plscript-insert-get_property)
       (global-set-key (kbd "C-x e") 'plscript-insert-page-elem)
       (global-set-key (kbd "C-x d") 'plscript-insert-page-dynamic)
       (global-set-key (kbd "C-b") 'plscript-add-break-point)
       (global-set-key (kbd "C-v") 'vc-diff)

       (add-hook 'plscript-mode-hook 'hs-plscript-mode-hook)
       (defun hs-plscript-mode-hook ()
	 (hs-minor-mode 1))
       ;;(global-set-key (kbd "M-<left>") 'hs-hide-block)
       ;;(global-set-key (kbd "M-<right>") 'hs-show-block)

       ;;from custom.el
       '(org-agenda-files
	 (quote
	  ("~/org/common.org" "~/org/today.org" "~/org/bayhealth.org" "~/org/bswqa.org")))
))
 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(initial-frame-alist (quote ((fullscreen . maximized)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
