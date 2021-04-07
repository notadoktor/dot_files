# setup

Add the following to the end of your `~/.bashrc` file:

```bash
### Load custom settings

if [[ -f "$HOME/.bash_extras/bashrc" ]]; then
    source "$HOME/.bash_extras/bashrc"
fi
```
