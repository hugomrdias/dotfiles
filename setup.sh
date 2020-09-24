#!/usr/bin/env bash

# https://github.com/kaicataldo/dotfiles/blob/master/bin/install.sh

#
# Utils
#

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
    && return 0 \
    || return 1
}

ask() {
    print_question "$1"
    read
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    read -n 1
    printf "\n"
}


ask_for_sudo() {
    
    # Ask for the administrator password upfront
    sudo -v
    
    # Update existing `sudo` time stamp until this script has finished
    # https://gist.github.com/cowboy/3118588
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &
    
}

cmd_exists() {
    [ -x "$(command -v "$1")" ] \
    && printf 0 \
    || printf 1
}

execute() {
    $1 &> /dev/null
    print_result $? "${2:-$1}"
}

get_answer() {
    printf "$REPLY"
}

get_os() {
    
    declare -r OS_NAME="$(uname -s)"
    local os=""
    
    if [ "$OS_NAME" == "Darwin" ]; then
        os="osx"
        elif [ "$OS_NAME" == "Linux" ] && [ -e "/etc/lsb-release" ]; then
        os="ubuntu"
    fi
    
    printf "%s" "$os"
    
}

is_git_repository() {
    [ "$(git rev-parse &>/dev/null; printf $?)" -eq 0 ] \
    && return 0 \
    || return 1
}

mkd() {
    if [ -n "$1" ]; then
        if [ -e "$1" ]; then
            if [ ! -d "$1" ]; then
                print_error "$1 - a file with the same name already exists!"
            else
                print_success "$1"
            fi
        else
            execute "mkdir -p $1" "$1"
        fi
    fi
}

print_error() {
    # Print output in red
    printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

print_info() {
    # Print output in purple
    printf "\n\e[0;35m $1\e[0m\n\n"
}

print_question() {
    # Print output in yellow
    printf "\e[0;33m  [?] $1\e[0m"
}

print_result() {
    [ $1 -eq 0 ] \
    && print_success "$2" \
    || print_error "$2"
    
    [ "$3" == "true" ] && [ $1 -ne 0 ] \
    && exit
}

print_success() {
    # Print output in green
    printf "\e[0;32m [✔] $1\e[0m\n"
}

# ask_for_confirmation "Warning: this will overwrite your current dotfiles. Continue?"
# if answer_is_yes; then
#     echo "";
# else
#     exit;
# fi


dir=~/dotfiles                        # dotfiles directory
dir_backup=~/dotfiles_old             # old dotfiles backup directory

# Get current dir (so run this script from anywhere)

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create dotfiles_old in homedir
print_info "Creating ${dir_backup} for backup of any existing dotfiles in ~..."
mkdir -p $dir_backup
print_success "done"

# Change to the dotfiles directory
# print_info "Changing to the $dir directory..."
# cd $dir
# print_success "done"

#
# Actual symlink stuff
#
declare -a FILES_TO_SYMLINK=(
    
    '.zshrc'
    '.gitattributes'
    '.gitconfig'
    '.gitignore'
    '.profile'
    # '.hushlogin'
    # '.macos'
    # '.hyper.js'
    # 'Brewfile'
    
)

print_info "Backing up files"
for i in ${FILES_TO_SYMLINK[@]}; do
    echo -ne "$i\n"
    mv ~/${i} ${dir_backup}
done
print_success "done"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    
    local i=''
    local sourceFile=''
    local targetFile=''
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    print_info "Symlinking files"
    for i in ${FILES_TO_SYMLINK[@]}; do
        
        sourceFile="$DOTFILES_DIR/$i"
        targetFile="$HOME/$i"
        
        if [ ! -e "$targetFile" ]; then
            execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
            elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
            print_success "$targetFile → $sourceFile"
        else
            ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
            if answer_is_yes; then
                rm -rf "$targetFile"
                execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
            else
                print_error "$targetFile → $sourceFile"
            fi
        fi
    done
    
    unset FILES_TO_SYMLINK
    print_success "done"
    
    # Copy binaries
    ln -fs $DOTFILES_DIR/bin $HOME
    
    #   declare -a BINARIES=(
    #     'batcharge.py'
    #     'crlf'
    #     'dups'
    #     'git-delete-merged-branches'
    #     'nyan'
    #     'passive'
    #     'proofread'
    #     'ssh-key'
    #     'weasel'
    #   )
    
    #   for i in ${BINARIES[@]}; do
    #     echo "Changing access permissions for binary script :: ${i##*/}"
    #     chmod +rwx $HOME/bin/${i##*/}
    #   done
    
    #   unset BINARIES
}

user=$(whoami);
platform=$(uname); # 'Linux' or 'Darwin'

ask_for_sudo

# Check for Homebrew
print_info "Check for Homebrew"
# Install if we don't have it
if test ! $(which brew); then
    print_info "Installing homebrew..."
    CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    if [[ $user == 'codespace' ]]; then
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    fi
    brew update
    brew upgrade
    print_success "done"
else
    print_success "Brew already installed"
fi

print_info "Install brew packages"
brew install hub starship gh fzf ncdu ripgrep bat prettyping yarn nano bash bash-completion2 zsh zsh-syntax-highlighting diff-so-fancy
brew cleanup
print_success "done"

print_info "Install yarn global packages"
yarn global add trash-cli serve yo tldr @cloudflare/wrangler
print_success "done"

# install better nanorc config
# https://github.com/scopatz/nanorc
print_info 'Installing a better nano highlighting'
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
print_success "done"

# Stuff specific to github codespaces
if [[ $user == 'codespace' ]]; then
    # switch to brew zsh needs .profile to make zsh default shell
    if ! fgrep -q '/home/linuxbrew/.linuxbrew/bin/zsh' /etc/shells; then
        echo '/home/linuxbrew/.linuxbrew/bin/zsh' | sudo tee -a /etc/shells;
    fi;
else
    # Switch to using brew-installed bash as default shell
    if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
        echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
        chsh -s /usr/local/bin/zsh;
    fi;
fi

 # Install Oh My Zsh if it isn't already present
if [[ ! -d ~/.oh-my-zsh/ ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

main