PROJECT_DIR := $(CURDIR)
VENV := source ${PROJECT_DIR}/.venv/bin/activate &&


.PHONY: setup
setup:
	python -m venv .venv
	${VENV} \
		pip install pre-commit "gdtoolkit==4.*" && \
		pre-commit install
	chmod +x ${PROJECT_DIR}/.git/hooks/pre-commit

.PHONY: format
format:
	 gdformat `git ls-files "*.gd"`

.PHONY: lint
lint:
	 gdlint `git ls-files "*.gd"` 2> lint.log
