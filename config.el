;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(setq doom-modeline-icon t)
(setq treemacs-use-icons t)
(setq treemacs-show-hidden-files t)
(setq doom-font (font-spec :family "Fira Code Nerd Font" :size 14))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;Ensuring emacs recognises theese
(add-to-list 'auto-mode-alist '("\\.sv\\'"  . verilog-mode))
(add-to-list 'auto-mode-alist '("\\.svh\\'" . verilog-mode))
(add-to-list 'auto-mode-alist '("\\.v\\'"   . verilog-mode))
(add-to-list 'auto-mode-alist '("\\.vh\\'"  . verilog-mode))

(add-to-list 'auto-mode-alist '("\\.l$" . lex-mode))
(add-to-list 'auto-mode-alist '("\\.y$" . yacc-mode))
(add-to-list 'auto-mode-alist '("\\.lex$" . lex-mode))
(add-to-list 'auto-mode-alist '("\\.yacc$" . yacc-mode))


;; ensuring neotree uses icons
(after! neotree
  (setq neo-theme 'icons))

;; ensuring projectile finds all projects in $HOME
(use-package! projectile
  :config
  (projectile-mode +1)
  (setq projectile-project-search-path '("~/"))
  (setq projectile-switch-project-action 'projectile-dired))

;; configuration for language servers

;; ensuring verilog knows about verible LS
;; (needs to be downloaded from github
;; and to be added to $PATH)
(use-package! verilog-ext
  :after verilog-mode
  :config
  (setq verilog-ext-eglot-set-server 'verible))

(after! verilog-mode
  (add-to-list 'eglot-server-programs
               '(verilog-mode . ("verible-verilog-ls"))))

(after! eglot
  ;;verilog
  (add-to-list 'eglot-server-programs
               '(verilog-mode . ("verible-verilog-ls")))
  (add-to-list 'eglot-server-programs
               '(verilog-ext-mode . ("verible-verilog-ls")))

  ;;c/c++
  (add-to-list 'eglot-server-programs
               '(c-mode . ("clangd")))
  (add-to-list 'eglot-server-programs
               '(c++-mode . ("clangd")))
  (add-to-list 'eglot-server-programs
               '(c-ts-mode . ("clangd")))
  (add-to-list 'eglot-server-programs
               '(c++-ts-mode . ("clangd"))))

;; syntax checker configuration
;; (not sure if really nedeed with eglot)
(use-package! flycheck)
(after! flycheck
  (flycheck-define-checker verilog-verible
    "Verible lint checker."
    :command ("verible-verilog-lint" source)
    :error-patterns
    ((error   line-start (file-name) ":" line ":" column ": " (message) line-end)
     (warning line-start (file-name) ":" line ":" column ": " (message) line-end))
    :modes (verilog-mode verilog-ext-mode))
  (add-to-list 'flycheck-checkers 'verilog-verible))

;; company configuration for autocompletion in code
(use-package! company
  :defer 2
  :diminish
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay .3)
  (company-minimum-prefix-length 3)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  (global-company-mode t))

(use-package! company-box
  :after company
  :diminish
  :hook (company-mode . company-box-mode))

;; configuration for russian keyboard in evil mode
(use-package! reverse-im
  :config
  (reverse-im-activate "russian-computer")
  (setq reverse-im-input-methods '("russian-computer")))

;; hooks for languages
(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)
(add-hook 'java-mode-hook #'eglot-ensure)
(add-hook 'verilog-mode-hook #'eglot-ensure)
(add-hook 'verilog-ext-mode-hook #'eglot-ensure)

;; changing numbering for coding purposes
(setq display-line-numbers-type 'relative)

;; Ensuring UTF-8 is prefered
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-unix)
(add-to-list 'file-coding-system-alist '("\\.txt\\'" . utf-8-unix))
