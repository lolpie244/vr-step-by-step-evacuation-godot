PROJECT_DIR := $(CURDIR)

ifneq ("$(wildcard ${PROJECT_DIR}/.venv)","")
VENV := source ${PROJECT_DIR}/.venv/bin/activate &&
else
VENV :=
endif


.PHONY: setup
setup:
	python -m venv .venv
	${VENV} \
		pip install pre-commit "gdtoolkit==4.*" && \
		pre-commit install
	chmod +x ${PROJECT_DIR}/.git/hooks/pre-commit

.PHONY: format
format:
	 ${VENV} gdformat `git ls-files "*.gd"`

.PHONY: lint
lint:
	 ${VENV} gdlint `git ls-files "*.gd"` 2> lint.log
