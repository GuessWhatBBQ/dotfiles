;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "GuessWhatBBQ"
      user-mail-address "saminslm@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 15)
      doom-unicode-font (font-spec :family "FuraMono Nerd Font":size 15))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-molokai)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

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


;; My Config
;;
;; Disabling the LSP formatter for specific modes
(setq-hook! 'rjsx-mode-hook +format-with-lsp nil)
;;
;; Disable prettify-symbols-mode on javascript to deal with firacode conflict?
(after! js
  (setq-default js--prettify-symbols-alist '()))
(use-package! vundo
  :defer t
  :init
  (defconst +vundo-unicode-symbols
    '((selected-node   . ?●)
      (node            . ?○)
      (vertical-stem   . ?│)
      (branch          . ?├)
      (last-branch     . ?╰)
      (horizontal-stem . ?─)))
  (map! :leader
        (:prefix ("o")
         :desc "vundo" "v" #'vundo))
  (setq-hook! 'vundo-mode-hook evil-emacs-state-cursor nil)
  (setq-hook! 'vundo-mode-hook evil-normal-state-cursor nil)

  :config
  (setq vundo-glyph-alist +vundo-unicode-symbols
        vundo-compact-display t
        vundo-window-max-height 6))
;; (add-hook! rjsx-mode
;;   (print prettify-symbols-alist))
;;
;; Setting up personal packages
(use-package! evil-textobj-line
  :after (evil))
(use-package! restclient-jq
  :after (restclient))
;;
;; Format and yank marked string with added information and prettifying
(defun kill-with-linenum (beg end)
  (interactive "r")
  (save-excursion
    (goto-char end)
    (skip-chars-backward "\n \t")
    (setq end (point))
    (let* ((chunk (buffer-substring beg end))
           (chunk (concat
                   (format "╭──────── Starting from line #%-d in %s ──\n│ "
                           (line-number-at-pos beg)
                           (file-relative-name buffer-file-name (projectile-project-root))
                           )
                   (replace-regexp-in-string "\n" "\n│ " chunk)
                   (format "\n╰──────── Ending at line #%-d ───────────────────"
                           (line-number-at-pos end)))))
      (kill-new chunk)))
  (deactivate-mark))

(map! :leader
      (:prefix ("y" . "yank")
       :desc "Prettified yank"
       "l" #'kill-with-linenum))
;;
(setq evil-goggles-enable-paste nil)

(global-visual-line-mode t)
