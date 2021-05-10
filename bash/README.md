# .bashrc

## Setup

- Run `make bash` from repo root
- Follow the steps in the Makefile to manually

## Customization

Computer / environment specific settings can be set in two ways:

1. Add category specific setings to a relavently named file with a suffix (_e.g.,_ `exports_work`, `secrets_aws`)
   - Custom category files are sourced after the repo files, but go in order (exports, exports_work, functions, aliases, aliases_work, ...)
   - Keeps things organized
2. Add settings to `local_settings`
   - This file is sourced last, so will take priority over any other files
   - Simple, single place to anything
