alias yt-dlp-720p="yt-dlp -f 'bestaudio[ext=m4a]+bestvideo[height<=720]'"
alias ssh-hosts="awk '/Host / {print $2}' ~/.ssh/config"
alias ssh-internal="ssh -A -J damien@ssh.alphagame.dev"

# Ansible
alias ansible="ansible -i hosts"
alias ansible-playbook="ansible-playbook -i hosts"

# Cloudflare WARP
alias warp="warp-cli"

# Bat -> 'batcat'
# odd command...?
alias bat="batcat"

# Allow for ctrl-c with the 'sl' command
alias sl="sl -e"

# The line of shame...
# I misspell 'cd' and write 'dc' instead...
alias dc="echo You misspelled a two-letter command you idiot && cd"
