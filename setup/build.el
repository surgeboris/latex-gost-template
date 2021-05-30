(with-eval-after-load 'ox-latex
  (let ((class-name "latex-gost-template"))
    (add-to-list 'org-latex-classes
      `(,class-name "\\documentclass[utf8x, 12pt]{G7-32}\n[NO-DEFAULT-PACKAGES]\n[NO-PACKAGES]"
         ("\\chapter{%s}" . "\\chapter*{%s}")
         ("\\section{%s}" . "\\section*{%s}")
         ("\\subsection{%s}" . "\\subsection*{%s}")
         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
         ("\\paragraph{%s}" . "\\paragraph*{%s}")
         ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
    (setq org-latex-pdf-process '("latexmk -e \\$bibtex_fudge=1 -pdf -f -outdir=%o %f"))))

(defun latex-gost-template/build (should-export-tex)
  (let ((delim "\n------------------------------\n\n")
         (success "SUCCESS!\n")
         (org-latex-listings t)
         (org-latex-logfiles-extensions nil))
    (condition-case err
      (progn
        (if should-export-tex
          (org-latex-export-to-latex)
          (org-latex-export-to-pdf))
        (let* ((buf (get-buffer-create "*Org PDF LaTeX Output*"))
                (log (or (with-current-buffer buf (buffer-string)) ""))
                (msg (concat delim log delim success delim)))
          (princ msg #'external-debugging-output)))
      (error (let* ((buf (get-buffer-create "*Org PDF LaTeX Output*"))
                     (log (or (with-current-buffer buf (buffer-string)) ""))
                     (msg (concat delim log delim (or (car (cdr err)) ""))))
               (error msg))))))

(defun latex-gost-template/build-pdf ()
  (latex-gost-template/build nil))

(defun latex-gost-template/build-tex ()
  (latex-gost-template/build t))
