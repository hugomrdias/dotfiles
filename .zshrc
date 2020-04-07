# PATH
PATH="${HOME}/n/bin:/usr/local/opt/openssl/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
PATH="$PATH:~/bin"
export PATH

export ZSH=~/.oh-my-zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git z yarn npm brew node)

source $ZSH/oh-my-zsh.sh

# Source local extra (private) settings specific to machine if it exists
[ -f ~/.zsh.local ] && source ~/.zsh.local

# EXPORTS

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nano'
else
    export EDITOR='code'
fi

# ALIASES

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; mas upgrade; brew update; brew upgrade --force-bottle; brew cleanup; brew doctor; yarn global upgrade --latest -s'

# Google Chrome
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash=" \
sudo rm -rfv /Volumes/*/.Trashes; \
sudo rm -rfv ~/.Trash; \
sudo rm -rfv /private/var/log/asl/*.asl; \
sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent' \
"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"


alias zshconfig="$EDITOR ~/.zshrc"
alias sshconfig="$EDITOR ~/.ssh/config"
alias hosts="sudo $EDITOR /etc/hosts"
alias dig="dig +nocmd any +multiline +noall +answer"

# better cat
alias cat='bat'

# wrap git with hub https://github.com/github/hub
alias git=hub

## better ping 
alias ping='prettyping --nolegend'

alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# better du
alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"

alias grep=rg

alias tldr=man

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# npm linked packages
alias npm-links='npm ls -g --depth=0 --link=true'

# Custom alias
alias ipfs-local='/Users/hugomrdias/code/pl/js-ipfs/src/cli/bin.js'

# To be able to install zsh-syntax-highlighting with brew this is needed
[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt pure

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
