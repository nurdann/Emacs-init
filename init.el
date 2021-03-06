
;;;;;;;;;;;;;;;;;;;;
;; INIT
;;;;;;;;;;;;;;;;;;;;

(load-file "~/.emacs.d/functions.el")
;; (setenv "BASH_ENV" "~/.bashrc")
;; (setq-default shell-command-switch "-c")
;; load same PATH as ~/.bashrc
;; (setenv "PATH" (shell-command-to-string "/bin/bash -i -c `/bin/echo -n $PATH`"))

(require 'package)

(setq package-archives
	  '(("gnu" . "https://elpa.gnu.org/packages/")
	    ("melpa-stable" . "https://stable.melpa.org/packages/")
	    ("melpa" . "https://melpa.org/packages/"))
	  package-archive-priorities
	  '(("melpa-stable" . 10)
	    ("gnu" . 5)
	    ("melpa" . 0)))

(package-initialize)
;;(setq package-check-signature  nil)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (eval-when-compile (require 'use-package))
  (require 'bind-key)) ;; required for :bind

(use-package diminish :ensure t)

;; Least frequent bigram combinations
;;      gb gp
;;  jj  jc jf jg jh jk jl jm jp jq js jt jv jw jx jy jz
;;  qq  qb qf qg qh qk ql qm qp qt qv qw qx qy qz
;;  vv  vc vf vg vh vk vm vp vw vz
;;  ww  xb xd xg xk xm xs xw
;;  yy  zb zd zf zg zk zm zp zs zw zx

(use-package use-package-chords
  :diminish key-chord-mode "Chord"
  :ensure t
  :config (key-chord-mode 1)
  (setq key-chord-two-keys-delay .025
        key-chord-one-key-delay .025))

;; Theme
(use-package humanoid-themes :ensure :defer)

(use-package circadian
  :ensure t
  :config
  (setq-default circadian-themes '(("8:00" . humanoid-light)
                                   ("19:00" . humanoid-dark)))
  (circadian-setup))

;;;;;;;;;;;;;;;;;;;;
;; Misc
;;;;;;;;;;;;;;;;;;;;

(setq-default ring-bell-function 'ignore ;; disable sound bell on error
              read-buffer-completion-ignore-case t
              read-file-name-completion-ignore-case t 
              indent-tabs-mode t
              tab-width 4
              tab-always-indent 'complete

              select-enable-clipboard t ;; copy/cut kill-ring to clipboard
              set-mark-command-repeat-pop t ;; After C-u C-SPC, C-SPC cycles through the mark ring
              shift-select-mode t
              auto-compression-mode t)

(setq-default backup-by-copying t
              backup-directory-alist '(("." . "~/.emacs.d/backup/"))
              delete-old-versions t
              kept-new-versions 6
              kept-old-versions 2)

(setq-default custom-file "~/.emacs.d/custom.el")
(if (file-exists-p custom-file)
    (load custom-file))

;; GUI
(menu-bar-mode 1)
(tool-bar-mode -1)
(size-indication-mode 1)

(if (version< emacs-version "26")
    (add-hook 'find-file-hook 'linum-mode) ;; add line numbers to opened files
  (add-hook 'text-mode-hook #'display-line-numbers-mode)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode))
(column-number-mode 1) ;; show column position in mode line

(auto-fill-mode -1)
(put 'set-goal-column 'disabled nil) ;; enable C-x C-n; disable C-u C-x C-n

;; Terminal
(let ((frame (framep (selected-frame))))
  (or (eq  t  frame)
      (eq 'pc frame)
      (define-key input-decode-map (kbd "C-[") [C-\[])
      (define-key input-decode-map "\C-i" [C-i])
      (define-key input-decode-map "\C-m" [C-m])
      (define-key input-decode-map "\C-j" [C-j])
      ))

;; remap defaults
(global-unset-key (kbd "C-z"))

;; remap ctl-x-map keys
;;(global-set-key (kbd "<menu>") ctl-x-map)
(define-key ctl-x-map (kbd "s") 'save-buffer) ;; same as C-x C-s
(define-key ctl-x-map (kbd "w") '(lambda () (interactive) (kill-buffer (buffer-name))))

;; Start up
(setq-default inhibit-startup-screen t
              initial-buffer-choice "~/Desktop/notes.md")
(kill-buffer "*scratch*")

;; scroll behaviour
(setq-default scroll-preserve-screen-position t)
(bind-key (kbd "<prior>") '(lambda () (interactive) (scroll-down-line 5)))
(bind-key (kbd "<next>") '(lambda () (interactive) (scroll-up-line 5)))

;; Mode line
(use-package smart-mode-line
  :ensure t
  :config 
  (setq-default
   sml/theme 'dark ;; 'light, 'dark, 'respectful
   sml/no-confirm-load-theme t
   sml/replacer-regexp-list nil
   sml/no-confirm-load-theme t)
  ;;(add-to-list 'sml/replacer-regexp-list '("^/sudo:root@.*:/" ":root:"))
  (add-hook 'circadian-after-load-theme-hook 'sml/setup))

(use-package command-log-mode
  ;; (command-log-mode)
  ;; (clm/open-command-log-buffer)
  :ensure t)

(use-package keyfreq
  :ensure t
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

(use-package which-key
  :ensure t
  :config (which-key-mode 1)
  :custom (which-key-idle-delay 0.4) 
  (which-key-idle-secondary-delay 0.4))

;;;;;;;;;;;;;;;;;;;;
;; CUSTOM MODES
;;;;;;;;;;;;;;;;;;;;

;; navigation mode

(define-minor-mode navi-mode
  "Toggle Navi Mode"
  :init-value nil
  :lighter " Navi"
  :group 'navi
  :keymap (let ((map (make-sparse-keymap)))
            (suppress-keymap map)
            (define-key map (kbd "i") 'navi-mode)
            (define-key map (kbd "p") 'scroll-down-line)
            (define-key map (kbd "n") 'scroll-up-line)
            (define-key map (kbd "k") 'backward-up-list)
            (define-key map (kbd "j") 'down-list)
            (define-key map (kbd "h") 'backward-list)
            (define-key map (kbd "l") 'forward-list)
            ;;(define-key map (kbd "u") 'backward-sexp)
            ;;(define-key map (kbd "i") 'forward-sexp)
            map))

(global-set-key (kbd "S-<return>") 'navi-mode)

;; menu prefix mode

(define-prefix-command 'menu-prefix-map)
(let ((map 'menu-prefix-map))
  (define-key map (kbd "t") 'find-file-other-window)
  (define-key map (kbd "r") 'alma/revert-current-buffer-or-visible-windows)
  (define-key map (kbd "w") '(lambda () (interactive) (kill-buffer (buffer-name))))
  (define-key map (kbd "=") 'enlarge-window)
  (define-key map (kbd "-") 'shrink-window)
  (define-key map (kbd "[") 'shrink-window-horizontally)
  (define-key map (kbd "]") 'enlarge-window-horizontally)
  (define-key map (kbd "1") 'delete-other-windows)
  (define-key map (kbd "2") 'split-window-below)
  (define-key map (kbd "3") 'split-window-right)
  (define-key map (kbd "4") 'delete-window)
  (define-key map (kbd "t") 'recentf-open-files)
  (define-key map (kbd "s") 'save-buffer)
  )

(bind-key (kbd "<menu>") 'menu-prefix-map)

(bind-key [f5] 'previous-buffer)
(bind-key [f6] 'next-buffer)

;;;;;;;;;;;;;;;;;;;;
;; Speciality MODES
;;;;;;;;;;;;;;;;;;;;

(if (file-directory-p "~/.emacs.d/packages/docker-tramp")
    (progn
      (add-to-list 'load-path "~/.emacs.d/packages/docker-tramp")
      (load "docker-tramp")))

(use-package dockerfile-mode
  :ensure t
  :mode (("Dockerfile\\'" . dockerfile-mode))
  :bind (:map dockerfile-mode-map
              ("C-c l" . dockerfile-build-buffer))
  :config
  (put 'dockerfile-image-name 'safe-local-variable #'stringp)
  (setq-default dockerfile-mode-command "docker"))

(use-package docker
  :ensure t
  :bind (:map menu-prefix-map
              ("n" . docker)))

(use-package magit
  :ensure t
  :bind (:map menu-prefix-map
              ("g" . magit-status)))

;;;;;;;;;;;;;;;;;;;;
;; Buffer
;;;;;;;;;;;;;;;;;;;;

;; display buffers in same window
(customize-set-variable 'display-buffer-alist
                        '(("^\\*shell.*\\*.*" . (display-buffer-same-window))
                          ("\\*Message\\*" . (display-buffer-same-window))))
(customize-set-variable 'Man-notify-method 'pushy)

(use-package winner
  ;; default keys C-c <arrow-key>
  :config (winner-mode 1))

;;;;;;;;;;;;;;;;;;;;
;; Editing
;;;;;;;;;;;;;;;;;;;;

(electric-pair-mode 1)
(electric-indent-mode 1)
(show-paren-mode 1)
(setq-default electric-indent-inhibit t)

(bind-key (kbd "c") 'copy-whole-line-at-cursor 'menu-prefix-map)

;;(use-package auto-complete :config  (ac-config-default))

(use-package company
  :ensure t
  :config
  (company-ac-setup)
  
  (add-hook 'emacs-lisp-mode-hook 'company-mode)
  (add-hook 'haskell-mode-hook 'company-mode)
  (add-hook 'haskell-interactive-mode-hook 'company-mode)
  ;;(setq company-backends '((company-files company-keywords company-capf company-dabbrev-code company-etags company-dabbrev)))

  ;;(company-sort-by-occurrence)
  :custom
  (company-dabbrev-downcase nil)
  (company-idle-delay 0.25)
  :bind (:map company-active-map
              ("<up>" . (lambda () (interactive)
						  (company-complete-common-or-cycle -1)))
              ("<down>" . (lambda () (interactive)
						  (company-complete-common-or-cycle 1)))))

(use-package undo-fu
  :ensure t
  :config
  :bind (
         ("C-z" . undo-fu-only-undo)
         ("C-S-z" . undo-fu-only-redo)
         ("C-M-z" . undo-fu-only-redo-all)))

;;;;;;;;;;;;;;;;;;;;
;; Navigating 
;;;;;;;;;;;;;;;;;;;;

(windmove-default-keybindings) ;; Shift <arrow-key> to move around windows

(global-set-key (kbd "M-[") 'backward-paragraph)
(global-set-key (kbd "M-]") 'forward-paragraph)
(bind-key (kbd "<home>") 'back-to-indentation-or-beginning-of-line)

(use-package ace-window
  :ensure t
  :init (ace-window t)
  (setq-default aw-keys '(?a ?s ?d ?f ?q ?w ?e ?r)) ;; limit characters
  :bind (:map ctl-x-map
              ("o" . ace-window)
              :map menu-prefix-map
              ("o" . ace-window)))

(use-package treemacs
  :ensure t
  :custom
  (treemacs-collapse-dirs 3)
  (treemacs-follow-after-init)
  (treemacs-persist-file (expand-file-name ".cache/treemacs-persist" user-emacs-directory))
  (treemacs-width 35)
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode t)
  :bind (:map menu-prefix-map
              ("t" . treemacs-select-window)))

;;;;;;;;;;;;;;;;;;;;
;; Files

(eval-after-load "dired-aux"
  '(add-to-list 'dired-compress-file-suffixes
                '("\\.zip\\'" ".zip" "unzip")))

;; view same buffer with two windows
;; C-x 3 M-x follow-mode

;; Default C-c C-v prefix map for vlf-mode
;; prompt when opening large files
(use-package vlf
  :ensure t
  :config
  (require 'vlf-setup))

(use-package itail
  :ensure
  :config
  (add-to-list 'auto-mode-alist '("\\.log\\'" . itail-mode))
  (add-hook 'itail-mode-hook 'end-of-buffer)
  )


(require 'recentf)
(setq-default recentf-auto-cleanup 'never) ;; otherwise tramp-mode will block emacs process
(recentf-mode 1)
(setq-default recentf-max-menu-items 200
              recentf-max-saved-items 200)


(use-package ido
  :config (ido-mode 1)
  (setq-default ido-enable-flex-matching t
                ido-everywhere t
                ido-auto-merge-work-directories-length -1
                ido-use-virtual-buffers t)
  :bind (:map menu-prefix-map
              ("f" . ido-find-file)
              ("b" . ido-switch-buffer)
              ("d" . ido-dired)
         :map ctl-x-map
              ("f" . ido-find-file)
              ("b" . ido-switch-buffer)
              ("d" . ido-dired)))

(use-package counsel
  :ensure t
  :config 
  (setq-default ivy-use-virtual-buffers t
                enable-recursive-minibuffers t)
  (setcdr (assoc 'counsel-M-x ivy-initial-inputs-alist) "")
  (setq-default mark-ring-max 100)
  :bind (
		 ("M-x" . counsel-M-x)
         :map menu-prefix-map
              ("x" . counsel-M-x)
              ("m" . counsel-mark-ring)
              ("v" . counsel-yank-pop)))

(use-package swiper
  :ensure t
  :bind (:map menu-prefix-map
              ("e" . swiper)))

(use-package dired
  :delight "Dired "
  :custom
  (dired-auto-revert-buffer t) ;; reverts buffer on visit
  (dired-hide-details-hide-symlink-targets nil)
  (dired-listing-switches "-alh")
  (dired-ls-F-marks-symlinks nil)
  (dired-recursive-copies 'always)
  (delete-by-moving-to-trash t)
  :config
  (put 'dired-find-alternate-file 'disabled nil)
  :bind (:map dired-mode-map
              ("RET" . dired-find-alternate-file)
              ("z" . open-in-external-app)
              ("b" . (lambda () (interactive) (find-alternate-file "..")))))

(use-package avy
  :ensure
  :custom
  (avy-time-out-seconds 0.7)
  :bind (("C-." . avy-goto-char-timer)
         :map menu-prefix-map
              ("SPC" . avy-goto-char-timer)))

;;;;;;;;;;;;;;;;;;;;
;; Language modes
;;;;;;;;;;;;;;;;;;;;

(use-package flycheck
  :ensure t
  :after (elpy)
  :config
  (when (require 'flycheck nil t)
	(setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
	(add-hook 'elpy-mode-hook 'flycheck-mode))

  ;; allow cell delimeters to start not strictly from beginning of line
  (setq elpy-shell-codecell-beginning-regexp "\\(?:##.*\\|#\\s-*<codecell>\\|#\\s-*In\\[.*\\]:\\)\\s-*$"
		elpy-shell-cell-boundary-regexp "\\(?:##.*\\|#\\s-*<.+>\\|#\\s-*\\(?:In\\|Out\\)\\[.*\\]:\\)\\s-*$"))

(use-package realgud
  :ensure t)

(use-package realgud-ipdb
  :ensure t)

;; SHELL

(use-package shell
  :config
  ;; Disable catching password prompt
  ;;(remove-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)
  
  (add-hook 'shell-mode-hook (lambda ()
							  (setq-local electric-pair-pairs (append electric-pair-pairs '((?\' . ?\') (?\` . ?\`))))
							  (setq-local electric-text-pairs electric-pair-pairs)))

  :bind (:map shell-mode-map
              ("<up>" . (lambda ()
                          (interactive)
                          (goto-char (point-max))
                          (comint-previous-input 1)))
              ("<down>" . (lambda ()
                            (interactive)
                            (goto-char (point-max))
                            (comint-next-input 1)))))

;; Haskell

;;(require 'haskell-interactive-mode)
;;(require 'haskell-process)
;; http://haskell.github.io/haskell-mode/manual/latest/Interactive-Haskell.html#Interactive-Haskell

(use-package lsp-haskell
  :ensure
  :config (setq lsp-haskell-process-path-hie "hie-wrapper"))

(use-package lsp-ui  :ensure t)

(use-package haskell-mode
  :ensure t
  :hook ((haskell-mode . (lambda ()
                           (lsp)
                           ;;(direnv-update-environment)
                           (lsp-ui-doc-mode)
                           ;;(haskell-collapse-mode)
						   (interactive-haskell-mode)
						   (haskell-doc-mode))))
  :config
  (custom-set-variables
   '(haskell-process-suggest-remove-import-lines nil)
   '(haskell-process-auto-import-loaded-modules nil)
   '(haskell-process-log t)
   '(haskell-process-type 'cabal-repl) ;; 'cabal-repl or 'stack-ghci

   ;; cabal install hasktags (make sure `hasktags` in PATH)
   ;; M-x visit-tags-table (Manually select TAGS file)
   '(haskell-tags-on-save t) 
   )

  ;; cabal install hasktags
  (let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
	(setenv "PATH" (concat my-cabal-path path-separator (getenv "PATH")))
	(add-to-list 'exec-path my-cabal-path))
  
  :bind (
		 :map haskell-mode-map
		 ("C-c C-l" . haskell-process-load-or-reload)
   		 ("C-c C-z" . haskell-interactive-switch)
         :map interactive-haskell-mode-map
		 ("M-." . haskell-mode-jump-to-def-or-tag)
         ("C-`" . haskell-interactive-bring)
         ("C-c f" . haskell-goto-first-error)
         :map haskell-cabal-mode-map
         ))

(use-package hindent
  :ensure t
  :config (add-hook 'haskell-mode-hook 'hindent-mode))

;; Markdown

(add-to-list 'load-path "~/.emacs.d/packages/markdown/")
(load "markdown-mode")
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :config
  (setq-default markdown-command "markdown")

  ;; add bullet point on enter
  ;;(setq-default markdown-indent-on-enter 'indent-and-new-item)

  (add-hook 'markdown-mode-hook (lambda ()
							  (setq-local electric-pair-pairs (append electric-pair-pairs '((?\` . ?\`))))
							  (setq-local electric-text-pairs electric-pair-pairs)))

  :bind (:map markdown-mode-map
              ("<return>" . markdown-custom-enter)
              ("C-`" . markdown-insert-gfm-code-block)))

;; cmake

(use-package cmake-mode
  :ensure t
  :config
  (setq-default auto-mode-alist (append
                                 '(("CMakeLists\\.txt\\'" . cmake-mode))
                                 '(("\\.cmake\\'" . cmake-mode))
                                 auto-mode-alist)))

;; mediawiki
(use-package mediawiki
  :ensure t
  :config
  (setq-default url-user-agent ""))


;; Python 
 
(use-package elpy
  :ensure t
  :init (elpy-enable)
  :config
  ;; pip install jupyter
  (setq python-shell-interpreter "jupyter"
		python-shell-interpreter-args "console --simple-prompt"
		python-shell-prompt-detect-failure-warning nil)
  (add-to-list 'python-shell-completion-native-disabled-interpreters "jupyter"))

(use-package ein
  :ensure t)

(use-package blacken
  ;; pip install blacken
  :ensure t
  :config
  ;;(add-hook 'python-mode-hook 'blacken-mode)
  )
