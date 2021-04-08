(when (boundp 'latex-gost-template/project-dir)
  (latex-gost-template/remove-export-tex-hook))

(setq latex-gost-template/project-dir (projectile-project-root))

(defun latex-gost-template/export-tex-hook ()
  (when (string= latex-gost-template/project-dir (projectile-project-root))
    (let ((default-directory latex-gost-template/project-dir)) (call-process-shell-command "make build-tex" nil 0))))

(add-hook 'after-save-hook 'latex-gost-template/export-tex-hook)

(defun latex-gost-template/remove-export-tex-hook ()
  (interactive)
  (makunbound 'latex-gost-template/project-dir)
  (remove-hook 'after-save-hook 'latex-gost-template/export-tex-hook)
  (fmakunbound 'latex-gost-template/export-tex-hook)
  (fmakunbound 'latex-gost-template/remove-export-tex-hook))
