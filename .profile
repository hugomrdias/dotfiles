user=$(whoami);
# If the platform is Linux, try an apt-get to install zsh and then recurse
if [[ $user == 'codespace' ]]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    export SHELL='/home/linuxbrew/.linuxbrew/bin/zsh'
    [ -z "$ZSH_VERSION" ] && exec "$SHELL" -l
fi