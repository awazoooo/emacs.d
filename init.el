; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; ------------------------------------------------------------------------
;; @ load-path

(add-to-list 'load-path "/path/to/z3-mode/")
(autoload 'z3-mode "z3-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . z3-mode))
(add-to-list 'auto-mode-alist '("\\.ml4\\'" . tuareg-mode))
(add-to-list 'auto-mode-alist '("\\.ML\\'" . sml-mode))

;; load-pathの追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(fset 'package-desc-vers 'package--ac-desc-version)
(package-initialize)

;; load-pathに追加するフォルダ
(add-to-load-path "elisp" "elpa")

;; テーマのロード
(load-theme 'afternoon t)
;;(load-theme 'black-on-gray t)
;;(load-theme 'blue-sea t)

;; ツールバー非表示
(tool-bar-mode -1)

;; スクロールバー非表示
(set-scroll-bar-mode nil)

;; メニューバーを非表示
(menu-bar-mode -1)

;; タイトルバーにファイルのフルパス表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))

;; オープニングメッセージを表示しない
(setq inhibit-startup-message t)

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;; 1行づつスクロールする
(setq scroll-conservatively 1)

;; 縦方向のスクロール行数を変更する。
(setq smooth-scroll/vscroll-step-size 1)

;; 横方向のスクロール行数を変更する。
(setq smooth-scroll/hscroll-step-size 1)

;; 対応する括弧をハイライトする
(show-paren-mode 1)

;; 対応する括弧の色の設定
(setq show-paren-style 'mixed)
(set-face-background 'show-paren-match-face "grey")
(set-face-foreground 'show-paren-match-face "black")

;; タブをスペースで扱う
(setq-default indent-tabs-mode nil)

;; yes or noをy or n
(fset 'yes-or-no-p 'y-or-n-p)

;; 予約語を色分けする
(global-font-lock-mode t)

;モードラインに時刻が表示
(display-time-mode 1)

;; モードラインに行番号表示
(line-number-mode t)

;; モードラインに列番号表示
(column-number-mode t)

;; C-Ret で矩形選択
;; 詳しいキーバインド操作：http://dev.ariel-networks.com/articles/emacs/part5/
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; ------------------------------------------------------------------------
;; @ key bind

;;descbinds-anything
;; (require 'descbinds-anything)
;; (descbinds-anything-install)

;;C-h
(keyboard-translate ?\C-h ?\C-?)

;; スクリーンの最大化
(set-frame-parameter nil 'fullscreen 'maximized)

;; Open .v files with Proof General's Coq mode
(load "~/.emacs.d/lisp/PG/generic/proof-site")
(load-file "${HOME}/.emacs.d/lisp/PG/generic/proof-site.el")

;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
(setq ring-bell-function 'ignore)

;; font size
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-12"))

;; カンマ、ピリオドを全角に変換(保存時)
(defun replace-dot-comma ()
  "s/。/．/g; s/、/，/g;する"
  (interactive)
  (let ((curpos (point)))
    (goto-char (point-min))
    (while (search-forward "。" nil t) (replace-match "．"))

    (goto-char (point-min))
    (while (search-forward "、" nil t) (replace-match "，"))
    (goto-char curpos)
    ))

;; latex modeのみ
(add-hook 'tex-mode-hook
          '(lambda ()
             (add-hook 'before-save-hook 'replace-dot-comma nil 'make-it-local)
                          ))

;; C-x C-q で view-mode
(setq view-read-only t)

;; view-minor-modeの設定
(add-hook 'view-mode-hook
          '(lambda()
             (progn
               ;; C-b, ←
               (define-key view-mode-map "h" 'backward-char)
               ;; C-n, ↓
               (define-key view-mode-map "j" 'next-line)
               ;; C-p, ↑
               (define-key view-mode-map "k" 'previous-line)
               ;; C-f, →
               (define-key view-mode-map "l" 'forward-char)
               )))

;; for go
(require 'go-mode)
(add-hook 'go-mode-hook
          '(lambda ()
             (setq tab-width 2)
             ))

;; for elscreen
(setq elscreen-prefix-key (kbd "C-z"))
(elscreen-start)
;;; タブの先頭に[X]を表示しない
(setq elscreen-tab-display-kill-screen nil)
;;; header-lineの先頭に[<->]を表示しない
(setq elscreen-tab-display-control nil)
;;; バッファ名・モード名からタブに表示させる内容を決定する(デフォルト設定)
(setq elscreen-buffer-to-nickname-alist
      '(("^dired-mode$" .
         (lambda ()
           (format "Dired(%s)" dired-directory)))
        ("^Info-mode$" .
         (lambda ()
           (format "Info(%s)" (file-name-nondirectory Info-current-file))))
        ("^mew-draft-mode$" .
         (lambda ()
           (format "Mew(%s)" (buffer-name (current-buffer)))))
        ("^mew-" . "Mew")
        ("^irchat-" . "IRChat")
        ("^liece-" . "Liece")
        ("^lookup-" . "Lookup")))
(setq elscreen-mode-to-nickname-alist
      '(("[Ss]hell" . "shell")
        ("compilation" . "compile")
        ("-telnet" . "telnet")
        ("dict" . "OnlineDict")
        ("*WL:Message*" . "Wanderlust")))
