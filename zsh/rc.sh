# zshrc
# to be sourced in.  Symlink to ~/.zshrc

# ----- install stuff if not already installed -----


p="zshrc:"
PLUGINSDIR="$HOME/.oh-my-zsh/custom/plugins"
THEMESDIR="$HOME/.oh-my-zsh/custom/themes"
CURRENTDIR=$(pwd)
function pull_plugin_from_git {
	# usage: <id> <repo>
	if [ ! -d "$PLUGINSDIR/$1" ]; then
		printf "$p Plugin '$1' doesn't exist. Installing... "
		# SILENCE IT. IT MUST NOT SPEAK
		git clone $2 $PLUGINSDIR/$1 --depth 1 2> /dev/null
		printf "done.\n"
	fi
}

function pull_theme_from_git {
	# usage: <id> <repo>
	if [ ! -d "$THEMESDIR/$1" ]; then
		printf "$p Theme '$1' doesn't exist. Installing... "
		# SILENCE IT. IT MUST NOT SPEAK
		git clone $2 $THEMESDIR/$1 --depth 1 2> /dev/null
		printf "done.\n"
	fi
}

pull_plugin_from_git command-time https://github.com/popstas/zsh-command-time.git
pull_plugin_from_git zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
pull_plugin_from_git you-should-use https://github.com/MichaelAquilina/zsh-you-should-use.git
pull_plugin_from_git zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
pull_plugin_from_git zsh-github-copilot https://github.com/loiccoyle/zsh-github-copilot.git

pull_theme_from_git  powerlevel10k https://github.com/romkatv/powerlevel10k.git
# --------------------------------------------------

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

ZSH_COMMAND_TIME_MIN_SECONDS=5
ZSH_COMMAND_TIME_MSG="Execution time: %s sec"
ZSH_COMMAND_TIME_COLOR="cyan"

YSU_MESSAGE_POSITION="after"
YSU_MODE=BESTMATCH
YSU_IGNORED_ALIASES=("g" "ll" "lsa")

plugins=(git 
		 python
		 ansible
		 command-time 
		 copyfile
		 zsh-github-copilot
		 zsh-syntax-highlighting 
		 you-should-use 
		 zsh-autosuggestions
)

if [ "$(uname)" = "Darwin" ]; then
	plugins+=macos
fi

if [ "$(uname)" = "Darwin" ]; then
	bindkey '»' zsh_gh_copilot_explain  # bind Option+shift+\ to explain
	bindkey '«' zsh_gh_copilot_suggest  # bind Option+\ to suggest
else
	bindkey '^[|' zsh_gh_copilot_explain  # bind Alt+shift+\ to explain
	bindkey '^[\' zsh_gh_copilot_suggest  # bind Alt+\ to suggest
fi


if test -n "$BASH" ; then script=$BASH_SOURCE
elif test -n "$TMOUT"; then script=${.sh.file}
elif test -n "$ZSH_NAME" ; then script=${(%):-%x}
elif test ${0##*/} = dash; then x=$(lsof -p $$ -Fn0 | tail -1); script=${x#n}
else script=$0
fi


SCRIPT_DIR=$(dirname $script)


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source $HOME/.dotfiles/import_all.sh


cd $CURRENTDIR
# the .. is because this script is in the zsh folder
/usr/bin/env python3 $SCRIPT_DIR/update_dotfiles.py 

source $ZSH/oh-my-zsh.sh

# I did not write this.  My friend did.  Please try to decipher it.
# =================================================================
# Long ago the master of spinjitsu created the sexy man boggy-poo, 
# master of all elements. But then the evil creature, DMEFRENCHOY 
# betayed boggy-poo and began a century long war to obtain the egg, 
# which containe the re encarnation of JeSUS Chist.

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
