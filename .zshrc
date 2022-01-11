export ANDROID_SDK_ROOT=/Users/hd/android-sdk
# PATH
PATH="/usr/local/opt/gnupg@2.2/bin:/usr/local/opt/openssl/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
PATH="$PATH:~/bin"
PATH=$PATH:$ANDROID_SDK_ROOT/emulator
PATH=$PATH:$ANDROID_SDK_ROOT/tools
PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH

export GPG_TTY=$(tty)
# make sure ssh can see gpg
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent


export ZSH=~/.oh-my-zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git brew node)

source $ZSH/oh-my-zsh.sh

[ -f ~/.profile ] && source ~/.profile

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

# scrcpy into mobile
alias mobile='scrcpy --tcpip=192.168.86.134:41453 -Sw --shortcut-mod=lalt'

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; mas upgrade; brew update; brew upgrade; brew cleanup; brew doctor; yarn global upgrade --latest -s; yarn cache clean'

# Google Chrome
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'

# IP addresses
alias ip="curl ipecho.net/plain; echo"
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
eval "$(hub alias -s)"

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

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# npm linked packages
alias npm-links='npm ls -g --depth=0 --link=true'

# Custom alias
alias ipfs-local='/Users/hugomrdias/code/pl/js-ipfs/src/cli/bin.js'

#fzf examples https://github.com/junegunn/fzf/wiki/Examples#git
# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | gsed -r 's/ *[0-9]*\*? *//' | gsed -r 's/\\/\\\\/g')
}


# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

fco_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

# fshow_preview - git commit browser with previews
fshow_preview() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
}




user=$(whoami);
# If the platform is github codespaces
if [[ $user == 'codespace' ]]; then
  [ -f /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  # To be able to install zsh-syntax-highlighting with brew this is needed
  [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
# linunx


# run `$(brew --prefix)/opt/fzf/install`` to install key binding and get `.fzf.zsh`, check with `bindkey`
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# https://starship.rs/
eval "$(starship init zsh)"

# githuh cli 
eval "$(gh completion -s zsh)"

# zoxide
eval "$(zoxide init --cmd j zsh)"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
