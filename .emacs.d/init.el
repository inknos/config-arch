;;; package --- melpa
;;; Commentary:
;;package initialization
(require 'package)
;;; Code:
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(defun require-package (evil)
  (setq-default highlight-tabs t)
  "Install given PACKAGE."
  (unless (package-installed-p evil)
    (unless (assoc evil package-archive-contents)
      (package-refresh-contents))
    (package-install evil)))

;; require and install packages
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    material-theme
    auctex
    auto-complete
    dtrt-indent
    elpy
    evil
    fill-column-indicator
    flycheck
    flycheck-pos-tip
    git
    highlight-parentheses
    magit
    sublimity
    powerline-evil
    py-autopep8))

(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)
;; end of required packages

(elpy-enable)

(xterm-mouse-mode t)

(require 'evil)
(evil-mode 1)

;; global buffer highlight parentheses
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;; parent mode enabled by default no delayed
(show-paren-mode 1)
(setq show-paren-delay 0)

;; additional infos
;; (require 'paren)
;; (set-face-background 'show-paren-match (face-background 'default))
;; (set-face-foreground 'show-paren-match "#def")
;; (set-face-attribute 'show-paren-match nil :weight 'extra-bold)

;; basic config for auto-complete
(ac-config-default)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (python-mode fill-column-indicator magit git dtrt-indent flycheck-pos-tip flycheck powerline-evil auctex highlight-parentheses evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; evil cursor
(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

;; powerline evil
(require 'powerline)
(powerline-evil-vim-color-theme)
(display-time-mode t)

;; esc quits
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

;;scroll down scroll Up
(define-key evil-normal-state-map (kbd "C-k") (lambda ()
                                                (interactive)
                                                (evil-scroll-up nil)))
(define-key evil-normal-state-map (kbd "C-j") (lambda ()
                                                (interactive)
                                                (evil-scroll-down nil)))

;;determine tab and enable it
(dtrt-indent-mode 1)

;;indent with return
(define-key global-map (kbd "RET") 'newline-and-indent)

;;do not move back cursor when exiting insert
(setq evil-move-cursor-back nil)

;;remeber cursor position when reopening files
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)
(require 'saveplace)

;;enable flycheck and flycheck-pos-tip
(add-hook 'after-init-hook #'global-flycheck-mode)
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;;delete whitespaces on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;autopep configuration
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;;format buffer
(defun iwb ()
  "Indent whole buffer."
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme

;;line numbers
(global-linum-mode t)

;;highlight line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#343d46")

;;handy switch buffer open/close files
(require 'ido)
(ido-mode t)

;;fill column indicator
(define-globalized-minor-mode
  global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode t)

(set-frame-font "DejaVu Sans Mono 12" nil t)

;;git
(require 'git)

                                        ;(provide 'init)\n;;; init.el ends here
