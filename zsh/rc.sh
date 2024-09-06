# zshrc
# to be sourced in.  Symlink to ~/.zshrc

# ----- install stuff if not already installed -----
p="zshrc:"
PLUGINSDIR="$HOME/.oh-my-zsh/custom/plugins"
function pull_plugin_from_git {
	# usage: <id> <repo>
	if [ ! -d "$PLUGINSDIR/$1" ]; then
		echo "$p $1 doesn't exist (Installing it!)"
		# SILENCE IT. IT MUST NOT SPEAK
		git clone $2 $PLUGINSDIR/$1 2> /dev/null
	fi
}

pull_plugin_from_git command-time https://github.com/popstas/zsh-command-time.git
pull_plugin_from_git zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
# --------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

ZSH_COMMAND_TIME_MIN_SECONDS=3
ZSH_COMMAND_TIME_MSG="Execution time: %s sec"
ZSH_COMMAND_TIME_COLOR="cyan"

plugins=(git command-time copyfile zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Change if needed
source $HOME/.dotfiles/import_all.sh

# I did not write this.  My friend did.  Please try to decipher it.
# =================================================================
# Long ago the master of spinjitsu created the sexy man boggy-poo, 
# master of all elements. But then the evil creature, DMEFRENCHOY 
# betayed boggy-poo and began a century long war to obtain the egg, 
# which containe the re encarnation of JeSUS Chist.
