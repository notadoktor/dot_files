SHELL = /bin/bash
HERE = $(shell dirname $(shell realpath -e $(lastword $(MAKEFILE_LIST))))
MV = mv -iv
MV_SUFFIX = $(shell date +%s)

INSTALL_ACTION ?= link
ifeq ($(INSTALL_ACTION),link)
INSTALL_CMD = ln -svf
else
ifeq ($(INSTALL_ACTION),copy)
INSTALL_CMD = cp -iv
$(error Not implemented quite yet)
else
$(error Invalid INSTALL_ACTION: $(INSTALL_ACTION). Must be one of: link, copy)
endif
endif

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo By default files are installed as symlinks, so changes are seen automatically. Set INSTALL_ACTION=copy
	@echo to copy them instead.

###

.PHONY: bash
EXTRAS_DIR ?= $(HOME)/.bash_extras
bash: ## set up .bashrc files
	@$(INSTALL_CMD) -n $(HERE)/bash "$(EXTRAS_DIR)"
	@grep -qs "source $(EXTRAS_DIR)" ~/.bashrc || echo "[[ -f $(EXTRAS_DIR)/bashrc ]] && source $(EXTRAS_DIR)/bashrc" >> $(HOME)/.bashrc
	@echo bash files have been set up successfully. open a new shell or exec bash to see changes

.PHONY: git
git: ## set up gitconfig
	@if [[ -f $(HOME)/.gitconfig && ! -h $(HOME)/.gitconfig ]]; then $(MV) $(HOME)/.gitconfig $(HOME)/.gitconfig.inc ; fi
	@$(INSTALL_CMD) $(HERE)/git/gitconfig $(HOME)/.gitconfig
	@echo gitconfig has been set up. user specific settings can be placed in $(HOME)/.gitconfig.inc

.PHONY: misc
misc: ## set up all files in misc/
	for fname in $(HERE)/misc/* ; do dot_fname=$(HOME)/.$$(basename $$fname); if [[ -e $$dot_fname && ! -h $$dot_fname ]]; then $(MV) $$fname $$dot_fname.$(MV_SUFFIX) ; fi; $(INSTALL_CMD) $$fname $$dot_fname ; done
	@echo finished setting up misc dot files
