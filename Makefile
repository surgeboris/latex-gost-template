SRC_DIR=$(shell pwd)/src
ORG_LATEX_SETUP=${SRC_DIR}/org-latex-setup.el
ENTRYPOINT=${SRC_DIR}/main.org

all: build
	make clean
build:
	emacs \
    --eval="(defun fix-path-if-win (p) (convert-standard-filename (replace-regexp-in-string \"^\/\\\\\\\\([a-z]\\\\\\\\)\" \"\\\\\\\\1:\" p)))" \
    --eval="(find-file (fix-path-if-win \"${ENTRYPOINT}\"))" \
    --eval="(cd (fix-path-if-win \"${SRC_DIR}\"))" \
    --eval="(load-file (fix-path-if-win \"${ORG_LATEX_SETUP}\"))" \
    --batch -f org-latex-setup/build --kill
clean:
	find ${SRC_DIR}/ -type f -regex ".*\.\(aux\|log\|tex~\)" -exec rm -f {} \; \
    && find ${SRC_DIR}/ -type f -regex ".*\/main\.\(bbl\|tex\)" -exec rm -f {} \;
