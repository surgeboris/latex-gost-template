(with-eval-after-load 'ox-latex
  (let ((class-name "org-latex-setup"))
    (add-to-list 'org-latex-classes
      `(,class-name "\\documentclass[utf8x, 12pt]{G7-32}\n[NO-DEFAULT-PACKAGES]\n[NO-PACKAGES]"
         ("\\chapter{%s}" . "\\chapter*{%s}")
         ("\\section{%s}" . "\\section*{%s}")
         ("\\subsection{%s}" . "\\subsection*{%s}")
         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
         ("\\paragraph{%s}" . "\\paragraph*{%s}")
         ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
    (setq org-latex-pdf-process '("latexmk -pdf -f -outdir=%o %f"))))

(defun org-latex-setup/build ()
  (let ((delim "\n------------------------------\n\n")
         (success "SUCCESS!\n")
         (org-latex-listings t))
    (condition-case err
      (progn
        (org-latex-export-to-pdf)
        (let* ((buf (get-buffer-create "*Org PDF LaTeX Output*"))
                (log (or (with-current-buffer buf (buffer-string)) ""))
                (msg (concat delim log delim success delim)))
          (princ msg #'external-debugging-output)))
      (error (let* ((buf (get-buffer-create "*Org PDF LaTeX Output*"))
                     (log (or (with-current-buffer buf (buffer-string)) ""))
                     (msg (concat delim log delim (or (car (cdr err)) ""))))
               (error msg))))))
