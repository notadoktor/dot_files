SHELL = /bin/bash

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

###

.PHONY: bash
EXTRAS_DIR ?= $(HOME)/.bash_extras
bash:
	ln -sfn . "$(EXTRAS_DIR)"
	grep -q ". $(EXTRAS_DIR)" ~/.bashrc || echo "[[ -f $(EXTRAS_DIR)/bashrc ]] && . $(EXTRAS_DIR)/bashrc" >> $(HOME)/.bashrc

.PHONY: git
git:
	[ -f $(HOME)/.gitconfig ] && mv $(HOME)/.gitconfig $(HOME)/.gitconfig.inc
	ln -s $(PWD)/gitconfig $(HOME)/.gitconfig
