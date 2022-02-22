# dots

My dotfiles in a bare Git repo.

## Initial Setup

Run the following commands:

```bash
git clone --bare git@github.com:emberquill/dots $HOME/.dots
alias dot='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
dot checkout --track origin/master
dot config --local status.showUntrackedFiles no
```
