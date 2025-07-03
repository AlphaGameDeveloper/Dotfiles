alias yt-dlp-720p="yt-dlp -f 'bestaudio[ext=m4a]+bestvideo[height<=720]'"
alias ssh-hosts="awk '/Host / {print $2}' ~/.ssh/config"
alias ssh-internal="ssh -A -J damien@ssh.alphagame.dev"
alias scp-internal="scp -o ProxyJump=damien@ssh.alphagame.dev"

# Ansible
alias ansible="ansible -i hosts"
alias ansible-playbook="ansible-playbook -i hosts"

# Cloudflare WARP
alias warp="warp-cli"

# Bat -> 'batcat'
# odd command...?
if [ "$(uname)" != "Darwin" ]; then
	alias bat="batcat"
fi

# Allow for ctrl-c with the 'sl' command
alias sl="sl -e"

# The line of shame...
# I misspell 'cd' and write 'dc' instead...
alias dc="echo You misspelled a two-letter command you idiot && cd"

# twingate
alias tw=twingate

alias octo="curl https://api.github.com/octocat"

function tree {
	[ "$DEBUG" != "" ] && echo "debug: using custom tree"
	TREEFLAGS=""
	
	if [ -f .gitignore ]; then
		[ "$DEBUG" != "" ] && echo "debug: .gitignore exists"
		TREEFLAGS="$TREEFLAGS --gitfile .gitignore"
	fi

	TREEFLAGS="$TREEFLAGS $*"
	
	CMD="command tree $TREEFLAGS"
	[ "$DEBUG" != "" ] && echo "debug: tree command '$CMD'"
	eval "$CMD"
}

function grbl {
	./gradlew assembleDebug installDebug
	adb shell am force-stop dev.alphagame.seen
	adb shell am start -n dev.alphagame.seen/.MainActivity
}

if [ "$(uname)" != "Darwin"]
