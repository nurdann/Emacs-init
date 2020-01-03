;; `C-n` move down a line
;; `C-p` move up a line
;; `C-f` move forward a character
;; `C-b` move backward a character
;; `M-ffff` move forward a word (alphanumeric sequence)
;; `M-b` move backward a word
;; `C-x C-f` find file and open
;; `C-x d` dired or show directory
;; `C-x b` show buffers which are usually currently opened files
;; `C-x C-c` exit emacs
;; `C-x C-s` save file
;; `C-x k` kill buffer

(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)
(package-refresh-contents)

;; go to line with (add-to-list ...)
;; and press `C-M-x` to evaluate lisp function; or move cursor the end of parenthesis and evaluate last expression with `C-x C-e`
;; then go to command menu `M-x` and type `list-packages` now you will see all available packages for download

;; CUA mode
;; default C-z undo, C-x cut, C-c copy, C-v paste
;; C-<enter> for rectangle edit; press <enter> to cycle through corners of selection
;; C-<number> use universal argument to save region to register <number>
(setq cua-delete-selection nil) ;; do not delete selection unless with delete command
(cua-mode t)

;; `S-<arrow-key>`, Shift <arrow-key> to move around windows
;; Some terminology: frame contains windows, so window is the buffer window in Emacs 
(windmove-default-keybindings)

;; Undo window layout
;; Default `C-c <left>' for `winner-undo', `C-c <right>' for `winner-redo'
;; Note: `C-c C-<left>' is different than `C-c <left>'
(winner-mode 1)

;; change default behaviour
(setq ring-bell-function 'ignore ;; disable sound bell on error
      select-enable-clipboard t ;; copy/cut kill-ring to clipboard
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t 
      window-combination-resize t
      tab-always-indent nil   ;; indent when point is left to text; otherwise insert tab
      tab-width 4   ;; set the size for tab
      indent-tabs-mode nil ;; use spaces instead of tab
      )

(menu-bar-mode 1)
(tool-bar-mode -1)
(auto-fill-mode -1) ;; you can set fill-column value with `C-x f`
(size-indication-mode 1) ;; show file size in mode line
(column-number-mode 1) ;; show column position in mode line
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)


;; save customization done via Emacs interface to different
;; folder, otherwise Emacs will append to init file
(setq custom-file "~/.emacs.d/custom.el")
(if (file-exists-p custom-file)
    (load custom-file))

;; Use `C-h` prefix to get help
;; `C-h f` describe function
;; `C-h v` describe variable
;; `C-h c` describe key sequence
;; `C-h m` describe mode

;; `M-x customize-themes' to choose from preset themes

(show-paren-mode 1)
(electric-pair-mode 1)
;; add additional pairs for quotation and curly braces
(setq electric-pair-pairs '((?\" . ?\")
			    (?\{ . ?\})))

;; C-x combo is very common so I remap it to a single key
(global-set-key (kbd "<menu>") ctl-x-map)
;; Then you either set global keybinding or add to a mode map
(define-key ctl-x-map (kbd "f") 'find-file)
;; OR 
(global-set-key (kbd "C-x f") 'find-file)

;; Find file

;; sudo
;; `C-x C-f /sudo::/` press <tab> or a character to get prompt
;; `C-x C-f /ssh:user@host:/`;; 

;;
;; consistent behaviour for opening buffers
(add-to-list 'display-buffer-alist '("^\\*.*\\*$" . (display-buffer-same-window)))

;; IDO mode
;; enhances behaviour of find-file and switch-buffer
;; `C-x C-f' opens `ido-find-file'; `C-f' while in mini-buffer switches to default `find-file'
(ido-mode 1)
(setq ido-enable-flex-matching t
      ido-everywhere t
      ido-auto-merge-work-directories-length -1
      ido-use-virtual-buffers t)


;; Dired `C-x d'
;; Commands in `dired-mode'
;; `n' move down
;; `p' move up
;; `m' mark file/folder
;; `u' or `<backspacke>' to unmark; `U' to unmark all
;; `R' move file, similar to `mv' command
;; `D' delete current file/folder
;; `d' mark for deletion
;; 'x' delete marked files/folders with `D' mark
(setq dired-listing-switches "-alh")
(setq dired-auto-revert-buffer t)

;; Terminal options
;; `eshell' written in elisp
;; `shell' uses dumb shell
;; `term' mimics terminal emulator; note that all `C-x' become `C-c' while `term' buffer is focused, so if you map it to something like `<menu>' you don't have to worry about it
;; Launch with `M-x' and type one of above names

;; You should not use `term' since it changes key-bindings which is confusing, and with `shell' or `eshell' you can take advantage of emacs commands.

;; Open shell `M-x shell <enter>'
;; Press `M-n' and `M-p' to go to next or previous command in history

;; To mimic terminal behaviour
;; Use `C-h c' to get command name of a key-combination
;; `C-h c M-p' gives `M-p runs the command comint-previous-input'
(define-key shell-mode-map (kbd "<up>") 'comint-previous-input)
(define-key shell-mode-map (kbd "<down>") 'comint-next-input)

;; Show key frequency with `M-x keyfreq-show'
(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

;; PUT this before `use-package' commands
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (eval-when-compile (require 'use-package))
  (require 'bind-key))

;; Convinience of use-package
(use-package keyfreq
             :ensure t
             :config
             (keyfreq-mode 1)
             (keyfreq-autosave-mode 1))

(use-package which-key
  :ensure t
  :config
  (which-key-mode 1)
  (setq which-key-idle-delay 0.4
        which-key-idle-secondary-delay 0.4))


;; automatically update `.log' files
;; similar to `tail -f'
(add-to-list 'auto-mode-alist '("\\.log\\'" . auto-revert-tail-mode))

;; open large file with small chunks
(use-package vlf
  :ensure t
  :config (require 'vlf-setup))

;; cycle kill-ring
(define-key cua--cua-keys-keymap (kbd "M-v") 'yank-pop)



