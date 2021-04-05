SRC_DIR=$(shell pwd)/src
OUT_DIR=$(shell pwd)/output
ORG_LATEX_SETUP=$(shell pwd)/setup/org-latex-setup.el
ENTRYPOINT=${SRC_DIR}/main.org

all: build
	make clean
build:
	emacs \
    --eval='(setenv "TEXINPUTS" "../vendor/:../src/tex/:")' \
    --eval='(setenv "BIBINPUTS" "../output/tex/:../src/tex/:")' \
    --eval='(setenv "BSTINPUTS" "../vendor/:")' \
    --eval="(defun fix-path-if-win (p) (convert-standard-filename (replace-regexp-in-string \"^\/\\\\\\\\([a-z]\\\\\\\\)\" \"\\\\\\\\1:\" p)))" \
    --eval="(find-file (fix-path-if-win \"${ENTRYPOINT}\"))" \
    --eval="(cd (fix-path-if-win \"${SRC_DIR}\"))" \
    --eval="(load-file (fix-path-if-win \"${ORG_LATEX_SETUP}\"))" \
    --batch -f org-latex-setup/build --kill
clean:
	find ${OUT_DIR}/ -type f -regex ".*\.\(aux\|bbl\|lol\|log\|out\|tex~?\)" -exec rm -f {} \;
