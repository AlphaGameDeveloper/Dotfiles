alias yt-dlp-720p="yt-dlp -f 'bestaudio[ext=m4a]+bestvideo[height<=720]'"
alias ssh-hosts="awk '/Host / {print $2}' ~/.ssh/config"
alias ssh-internal="ssh -A -J damien@ssh.alphagame.dev"
