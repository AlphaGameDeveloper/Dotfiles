# zshrc
# to be sourced in.  Symlink to ~/.zshrc

# ----- install stuff if not already installed -----

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

p="zshrc:"
PLUGINSDIR="$HOME/.oh-my-zsh/custom/plugins"
THEMESDIR="$HOME/.oh-my-zsh/custom/themes"
function pull_plugin_from_git {
	# usage: <id> <repo>
	if [ ! -d "$PLUGINSDIR/$1" ]; then
		printf "$p Plugin '$1' doesn't exist. Installing... "
		# SILENCE IT. IT MUST NOT SPEAK
		local START_MS=$(($(date +%s%N)/1000000))
		git clone $2 $PLUGINSDIR/$1 --depth 1 2> /dev/null
		local END_MS=$(($(date +%s%N)/1000000))

		printf "done. ($(($END_MS-$START_MS)) ms)\n"
	fi
}

function pull_theme_from_git {
	# usage: <id> <repo>
	if [ ! -d "$THEMESDIR/$1" ]; then
		printf "$p Theme '$1' doesn't exist. Installing... "
		# SILENCE IT. IT MUST NOT SPEAK
		local START_MS=$(($(date +%s%N)/1000000))
		git clone $2 $THEMESDIR/$1 --depth 1 2> /dev/null
		local END_MS=$(($(date +%s%N)/1000000))
				
		printf "done. ($(($END_MS-$START_MS)) ms)\n"
	fi
}

pull_plugin_from_git command-time https://github.com/popstas/zsh-command-time.git
pull_plugin_from_git zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
pull_plugin_from_git you-should-use https://github.com/MichaelAquilina/zsh-you-should-use.git
pull_plugin_from_git zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git

pull_theme_from_git  powerlevel10k https://github.com/romkatv/powerlevel10k.git
# --------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

ZSH_COMMAND_TIME_MIN_SECONDS=3
ZSH_COMMAND_TIME_MSG="Execution time: %s sec"
ZSH_COMMAND_TIME_COLOR="cyan"

YSU_MESSAGE_POSITION="after"
YSU_MODE=BESTMATCH
YSU_IGNORED_ALIASES=("g" "ll" "lsa")

plugins=(git 
		 command-time 
		 copyfile 
		 zsh-syntax-highlighting 
		 you-should-use 
		 zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source $HOME/.dotfiles/import_all.sh

# I did not write this.  My friend did.  Please try to decipher it.
# =================================================================
# Long ago the master of spinjitsu created the sexy man boggy-poo, 
# master of all elements. But then the evil creature, DMEFRENCHOY 
# betayed boggy-poo and began a century long war to obtain the egg, 
# which containe the re encarnation of JeSUS Chist.

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
