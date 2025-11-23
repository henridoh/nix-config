;; Emacs Configuration
(setopt inhibit-splash-screen t)
(setopt scroll-step 1)
(recentf-mode 1)
(global-auto-revert-mode 1)
(put 'narrow-to-region 'disabled nil)
(global-unset-key (kbd "C-z"))
(add-hook 'prog-mode-hook
          (lambda ()
            (setopt show-trailing-whitespace t)))
;; (set-face-attribute 'default nil :height 140)

(setopt use-package-compute-statistics t)

(use-package display-line-numbers-mode
  :hook (prog-mode text-mode conf-mode))

(use-package hl-line-mode
  :hook (prog-mode text-mode conf-mode))

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

(electric-indent-mode -1)
