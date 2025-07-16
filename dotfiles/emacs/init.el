;; .emacs

;; Initialize straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; GCMH - Do this at the beginning so we can maybe start up a bit
;; faster
(straight-use-package 'gcmh)
(gcmh-mode 1)

;; use-package
(straight-use-package 'use-package)

;; Packages
;; Major modes
(straight-use-package 'markdown-mode)
(straight-use-package 'rust-mode)
(straight-use-package 'haskell-mode)
(straight-use-package 'fish-mode)
(straight-use-package 'yaml-mode)
(straight-use-package 'cmake-mode)

(define-minor-mode remove-trailing-whitespace-mode
  "Minor mode to remove trailing whitespace on every save"
  (add-hook 'before-save-hook 'delete-trailing-whitespace))

(add-hook 'prog-mode-hook 'remove-trailing-whitespace-mode)

;; Other stuff
(straight-use-package 'better-defaults)
(straight-use-package 'delight)
(straight-use-package 'doom-themes)
(straight-use-package 'undo-tree)
(straight-use-package 'multiple-cursors)
(straight-use-package 'which-key)
(straight-use-package 'rainbow-delimiters)
(straight-use-package 'hl-todo)
(straight-use-package 'orderless)
(straight-use-package 'vertico)
(straight-use-package 'consult)
(straight-use-package 'marginalia)
(straight-use-package 'embark)
(straight-use-package 'embark-consult)
(straight-use-package 'company)
(straight-use-package 'lsp-mode)
(straight-use-package 'speed-type)
(straight-use-package 'magit)
(straight-use-package 'restart-emacs)
;; (straight-use-package 'mingus)
(straight-use-package 'ace-window)
;; (straight-use-package 'projectile)
;; (straight-use-package 'osm)
(straight-use-package 'editorconfig)
(straight-use-package 'exec-path-from-shell)
(straight-use-package 'pyvenv)
(straight-use-package 'ellama)
(straight-use-package 'proof-general)

;; Emacs Configuration
(setq inhibit-splash-screen t)
(setq scroll-step 1)
(recentf-mode 1)
(global-auto-revert-mode 1)
(put 'narrow-to-region 'disabled nil)
(global-unset-key (kbd "C-z"))
(setq mac-command-modifier 'meta
      mac-option-modifier nil)
;; (set-face-attribute 'default nil :height 140)

(setq use-package-compute-statistics t)

(use-package display-line-numbers-mode
  :hook (prog-mode text-mode conf-mode))

(use-package hl-line-mode
  :hook (prog-mode text-mode conf-mode))

(use-package gcmh
  :delight)

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package undo-tree
  :config
  (global-undo-tree-mode)
  :custom
  (undo-tree-auto-save-history nil)
  :delight)

(use-package which-key
  :config
  (which-key-mode)
  :delight)

(use-package doom-themes
  :config
  (load-theme 'doom-one t))

(use-package better-defaults)

(use-package multiple-cursors
  :bind (("C-x C-l" . mc/edit-lines)
         ("C-x C-n" . mc/mark-next-like-this)
         ("C-x C-p" . mc/mark-previous-like-this)))

(use-package rainbow-delimiters-mode
  :hook prog-mode)

(use-package hl-todo-mode
  :hook prog-mode)

(use-package orderless
  :custom (completion-styles '(orderless)))

(use-package vertico
  :init
  (ido-mode 0)
  (vertico-mode))

(use-package consult
  :bind (("C-c i" . consult-imenu)
         ("C-x b" . consult-buffer)))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package company
  :config
  (global-company-mode)
  :bind (("C-." . company-complete)))

(use-package ace-window
  :custom
  (aw-keys '(?h ?i ?e ?a ?t ?r ?n ?s))
  :bind (("C-x o" . ace-window)))

(use-package editorconfig
  :config
  (editorconfig-mode 1)
  :delight)

(use-package embark
  :bind (("C-M-x" . embark-act)))

(electric-indent-mode -1)
(remove-hook 'before-save-hook 'delete-trailing-whitespace)
