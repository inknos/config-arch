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
    evil
    fill-column-indicator
    flycheck
    flycheck-pos-tip
    git
    highlight-parentheses
    magit
    sublimity
    powerline-evil))

(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)
;; end of required packages

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
    (fill-column-indicator magit git dtrt-indent flycheck-pos-tip flycheck powerline-evil auctex highlight-parentheses evil))))
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

;;smooth scrolling
;;(setq scroll-margin 5
;;      scroll-conservatively 9999
;;      scroll-step 1)

;;(setq scroll-margin 1
;;      scroll-conservatively 0
;;      scroll-up-aggressively 0.01
;;      scroll-down-aggressively 0.01)
;;(setq-default scroll-up-aggressively 0.01
;;	      scroll-down-aggressively 0.01)
;;(setq scroll-step           1
;;      scroll-conservatively 10000)
;; scroll one line at a time (less "jumpy" than defaults)
;;(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
;;(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
;;(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse    
;;(setq scroll-step 1) ;; keyboard scroll one line at a time

;;enable flycheck and flycheck-pos-tip
(add-hook 'after-init-hook #'global-flycheck-mode)

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

(set-frame-font "Inconsolata 13" nil t)

;;git
(require 'git)

                                        ;(provide 'init)\n;;; init.el ends here
