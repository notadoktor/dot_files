SHELL = /bin/bash
HERE = $(shell dirname $(shell realpath -e $(lastword $(MAKEFILE_LIST))))

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

###

.PHONY: bash
EXTRAS_DIR ?= $(HOME)/.bash_extras
bash: ## set up .bashrc files
	@ln -sfn $(HERE)/bash "$(EXTRAS_DIR)"
	@grep -qs "source $(EXTRAS_DIR)" ~/.bashrc || echo "[[ -f $(EXTRAS_DIR)/bashrc ]] && source $(EXTRAS_DIR)/bashrc" >> $(HOME)/.bashrc
	@echo bash files have been set up successfully. open a new shell or exec bash to see changes

.PHONY: git
git: ## set up gitconfig
	@if [[ -f $(HOME)/.gitconfig && ! -h $(HOME)/.gitconfig ]]; then mv -i $(HOME)/.gitconfig $(HOME)/.gitconfig.inc ; fi
	@ln -sf $(HERE)/git/gitconfig $(HOME)/.gitconfig
	@echo gitconfig has been set up. user specific settings can be placed in $(HOME)/.gitconfig.inc
