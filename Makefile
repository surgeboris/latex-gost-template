SRC_DIR=${PWD}/src
ORG_LATEX_SETUP=${SRC_DIR}/org-latex-setup.el
ENTRYPOINT=${SRC_DIR}/main.org

all: build
	make clean
build:
	emacs ${ENTRYPOINT} \
    --eval="(cd \"${SRC_DIR}\")" \
    --eval="(load-file \"${ORG_LATEX_SETUP}\")" \
    --batch -f org-latex-setup/build --kill
clean:
	find ${SRC_DIR}/ -type f -regex ".*\.\(aux\|log\|tex~\)" -exec rm -f {} \; \
    && find ${SRC_DIR}/ -type f -regex ".*\/main\.\(bbl\|tex\)" -exec rm -f {} \;
