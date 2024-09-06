# zshrc
# to be sourced in.  Symlink to ~/.zshrc

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

ZSH_COMMAND_TIME_MIN_SECONDS=3
ZSH_COMMAND_TIME_MSG="Execution time: %s sec"
ZSH_COMMAND_TIME_COLOR="cyan"

plugins=(git command-time copyfile)

source $ZSH/oh-my-zsh.sh
source $HOME/.dotfiles/import_all.sh

