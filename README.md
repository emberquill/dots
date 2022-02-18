# dots

My dotfiles in a bare Git repo.

## Initial Setup

Run the following commands:

```bash
git clone --bare git@github.com:emberquill/dots $HOME/.dots
alias dots='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
dots checkout --force # WARNING: will overwrite existing files with the repo version
dots config --local status.showUntrackedFiles no
```
