SRC_DIR=$(shell pwd)/src
OUT_DIR=$(shell pwd)/output
ORG_LATEX_SETUP=$(shell pwd)/setup/build.el
ENV_LATEX_SETUP=$(shell pwd)/setup/latex-env.sh
ENTRYPOINT=${SRC_DIR}/main.org

.PHONY: all
all: build-pdf
	make clean

build:
	make build-pdf

.PHONY: build-pdf build-tex
build-pdf build-tex:
	:; \
    . ${ENV_LATEX_SETUP}; \
    emacs \
    --eval="(defun fix-path-if-win (p) (convert-standard-filename (replace-regexp-in-string \"^\/\\\\\\\\([a-z]\\\\\\\\)\" \"\\\\\\\\1:\" p)))" \
    --eval="(find-file (fix-path-if-win \"${ENTRYPOINT}\"))" \
    --eval="(cd (fix-path-if-win \"${SRC_DIR}\"))" \
    --eval="(load-file (fix-path-if-win \"${ORG_LATEX_SETUP}\"))" \
    --batch -f latex-gost-template/$@ --kill

.PHONY: clean
clean:
	find ${OUT_DIR}/ -type f -regex ".*\.\(aux\|bbl\|blg\|fdb_latexmk\|fls\|lol\|log\|out\|tex~?\|toc\)" -exec rm -f {} \;

.PHONY: watch
watch: build-tex
# in order for org-mode changes to be reflected call `load-file` with ./setup/export-tex-hook.el
	. ${ENV_LATEX_SETUP}; \
    cd ./src; \
    latexmk -pdf -f -pvc -outdir=../output -view=none ../output/main.tex
