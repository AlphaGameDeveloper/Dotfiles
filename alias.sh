alias yt-dlp-720p="yt-dlp -f 'bestaudio[ext=m4a]+bestvideo[height<=720]'"
alias ssh-hosts="awk '/Host / {print $2}' ~/.ssh/config"
alias ssh-internal="ssh -A -J damien@ssh.alphagame.dev"

# Ansible
alias ansible="ansible -i hosts"
alias ansible-playbook="ansible-playbook -i hosts"

# Cloudflare WARP
alias warp="warp-cli"
