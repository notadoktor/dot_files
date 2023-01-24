SHELL = /bin/bash
HERE = $(shell dirname $(shell realpath -e $(lastword ${MAKEFILE_LIST})))
MV = mv -iv
MV_SUFFIX = $(shell date +%s)

INSTALL_ACTION ?= link
ifeq (${INSTALL_ACTION},link)
INSTALL = ln -svf
INSTALL_DIR = ${INSTALL} -n
else
ifeq (${INSTALL_ACTION},copy)
INSTALL = cp -iv
INSTALL_DIR = ${INSTALL} -r
$(error Not implemented quite yet)
else
$(error Invalid INSTALL_ACTION: ${INSTALL_ACTION}. Must be one of: link, copy)
endif
endif

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo By default files are installed as symlinks, so changes are seen automatically. Set INSTALL_ACTION=copy
	@echo to copy them instead.

###

.PHONY: bash
EXTRAS_DIR ?= ${HOME}/.bash_extras
bash: ## set up .bashrc files
	@${INSTALL} -n ${HERE}/bash "${EXTRAS_DIR}"
	@grep -qs "source ${EXTRAS_DIR}" ~/.bashrc || echo "[[ -f ${EXTRAS_DIR}/bashrc ]] && source ${EXTRAS_DIR}/bashrc" >> ${HOME}/.bashrc
	@echo bash files have been set up successfully. open a new shell or exec bash to see changes

.PHONY: git
git: ## set up gitconfig
	@if [[ -f ${HOME}/.gitconfig && ! -h ${HOME}/.gitconfig ]]; then ${MV} ${HOME}/.gitconfig ${HOME}/.gitconfig.inc ; fi
	@${INSTALL} ${HERE}/git/gitconfig ${HOME}/.gitconfig
	@echo gitconfig has been set up. user specific settings can be placed in ${HOME}/.gitconfig.inc

.PHONY: misc
misc: ## set up all files in misc/
	for fname in ${HERE}/misc/* ; do dot_fname=${HOME}/.$$(basename $$fname); if [[ -e $$dot_fname && ! -h $$dot_fname ]]; then ${MV} $$fname $$dot_fname.${MV_SUFFIX} ; fi; ${INSTALL} $$fname $$dot_fname ; done
	@echo finished setting up misc dot files

.PHONY: util
UTIL_DIR = ${HOME}/.local/bin
util: ## set up util scripts in $UTIL_DIR
	$(if $(wildcard ${UTIL_DIR}), , mkdir -p ${UTIL_DIR})
	@${INSTALL} ${HERE}/util/* ${UTIL_DIR}/
	@echo finished setting up util scripts

.PHONY: vscode vscode-snippets vscode-settings
CODE_DIR ?= ${HOME}/.config/Code/User

vscode-snippets: SNIP_DIR = ${CODE_DIR}/snippets
vscode-snippets: ## set up vscode snippets
	@if [[ -d ${SNIP_DIR} && ! -L ${SNIP_DIR} ]]; then echo "moving existing snippets to ${SNIP_DIR}.old"; ${MV} ${SNIP_DIR} ${SNIP_DIR}.old; fi
	${INSTALL_DIR} ${HERE}/vscode/snippets ${SNIP_DIR}

vscode-settings: CODE_SETTINGS = ${CODE_DIR}/settings.json
vscode-settings: ## set up vscode settings
	if [[ -e ${CODE_SETTINGS} ]]; then echo "moving existing settings to ${CODE_SETTINGS}.old"; ${MV} ${CODE_SETTINGS} ${CODE_SETTINGS}.old; fi
	${INSTALL} ${HERE}/vscode/settings.json ${CODE_SETTINGS}

vscode: vscode-settings vscode-snippets ## set up all vscode files
