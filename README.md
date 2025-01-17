# Dotfiles
My dotfiles for my Linux development machines.
# Using it!
I am currently working on an automatic installer for it... 

```zsh
zsh -c "$(curl https://raw.githubusercontent.com/AlphaGameDeveloper/Dotfiles/refs/heads/AlphaGameDeveloper-patch-1/fresh_install.sh)"
```
but it is a work in progress.  Right now, you should:
```zsh
cd ~ && \
git clone https://github.com/AlphaGameDeveloper/Dotfiles.git .dotfiles && \
echo "source $(pwd)/.dotfiles/zsh/rc.sh" > ~/.zshrc && \
echo "source $(pwd)/.dotfiles/zsh/p10k.zsh" > ~/.p10k.zsh && \
source ~/.zshrc
```
