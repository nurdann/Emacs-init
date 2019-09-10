;; C-h c <command> to get output of command sequence

(require 'package)

(add-to-list 'package-archives
			 '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
;(package-refresh-contents)

(eval-when-compile (require 'use-package))

;(setq custom-safe-themes t) ;; skip prompt
;(when (display-graphic-p)
;  (load-theme 'dracula t))

(use-package circadian
  :config
  (setq circadian-themes '(("8:00" . parchment)
			   ("19:00" . creamsody)))
  (circadian-setup))


;;;;;;;;;;;;;;;;;;;;
;; Misc
;;;;;;;;;;;;;;;;;;;;

(menu-bar-mode -1)
(tool-bar-mode -1)
;(global-linum-mode t)
;(setq cursor-type '(hbar . 4))
(auto-fill-mode -1)
;(scroll-bar-mode -1)
(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs.d/backup/"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(global-unset-key (kbd "C-z"))
		  
;;;;;;;;;;;;;;;;;;;;
;; Buffer
;;;;;;;;;;;;;;;;;;;;

;(switch-to-buffer (shell-get-buffer-create))
;(put 'mini)

;;;;;;;;;;;;;;;;;;;;
;; Editing
;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-c C-k") 'copy-current-line)

(show-paren-mode 1)

;; Allow undo/redo
;; Default C-c left/right arrow
(use-package winner
  :config (winner-mode 1)
  :bind (("C-c <left>" . undo)
	 ("C-c <right>" . redo)))

;(electric-indent-mode)
(use-package electric
  :config
  (electric-pair-mode 1)
  (setq electric-pair-pairs '((?\" . ?\")
			      (?\{ . ?\}))))

(use-package auto-complete
  :init (auto-complete-mode t)
  :config
  (ac-set-trigger-key "<tab>")
  (ac-config-default)
  (setq ac-delay 0.02
	))

(use-package keyfreq
  :config
  (keyfreq-mode t)
  (keyfreq-autosave-mode t))

(use-package undo-tree
  :init (global-undo-tree-mode)
  :bind (("C-S-z" . undo-tree-redo)
	 ("C-z" . undo-tree-undo)))

(global-unset-key (kbd "C-x s"))
(global-set-key (kbd "C-x s") 'save-buffer) ;; same as C-x C-s

;;;;;;;;;;;;;;;;;;;;
;; Navigating 
;;;;;;;;;;;;;;;;;;;;

;(use-package evil
;  :init
;  (evil-mode t))

(define-key input-decode-map "\C-i" [C-i])
(use-package ace-jump-mode
  :bind (("C-S-j" . ace-jump-char-mode)
	 ("C-j" . ace-jump-word-mode)))

(windmove-default-keybindings) ;; Shift <arrow-key> to move windows

;(use-package window-numbering
;  :init (window-numbering-mode t))

(use-package ace-window
  :init (ace-window t)
  (setq aw-keys '(?a ?s ?d ?f ?g)) ;; limit characters
  :bind ("C-;" . ace-window))

(use-package helm
  :init
  (helm-mode t)
  (helm-autoresize-mode t) ;; grow buffer as needed
  (setq helm-split-window-in-side-p t ;; split based on current buffer
	helm-move-to-line-cycle-in-source t ;; cycle options when reaching end/start of buffer
	;helm-autoresize-max-height 50
	;helm-autoresize-min-height 25
	)
  :bind (("M-x" . helm-M-x)
	 ("C-x f" . helm-find-files)
	 ("C-x b" . helm-buffers-list)
	 ("C-x C-f" . helm-recentf)
	 :map helm-find-files-map
	 ("DEL" . helm-find-files-up-one-level)))


;; Matlab
;(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
;(add-to-list 'auto-mode-alist '("\\.m$" . matlab-mode))
;(setq matlab-indent-function t)
;(setq matlab-shell-command "matlab")
;
;(add-to-list 'load-path "~/.emacs.d/packages/ematlab")
;(load-library "matlab")
;
;(define-key matlab-mode-map (kbd "C-c l") 'matlab-shell-run-cell)
;(define-key matlab-mode-map (kbd "C-c C-l") 'matlab-shell-run-region)
;(define-key matlab-mode-map (kbd "C-S-l") 'matlab-shell-save-and-go)


;;;;;;;;;;;;;;;;;;;;
;; Functions
;;;;;;;;;;;;;;;;;;;;

(defun copy-current-line ()
  (interactive)
  (kill-ring-save (line-beginning-position)
				  (line-end-position))
  (message "Copied current line"))

