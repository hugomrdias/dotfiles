#!/usr/bin/env bash

## UTILS
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



print_info() {
    # Print output in purple
    printf "\n\e[0;35m $1\e[0m\n\n"
}

print_success() {
    # Print output in green
    printf "\e[0;32m [✔] $1\e[0m\n"
}

## Start
ask_for_sudo

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
    print_info "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    print_success "done"
fi

# Install mas
print_info 'Install mas and update/upgrade brew'
if test ! $(which mas); then
    print_info "Installing mas..."
    brew install mas
fi
brew update
brew upgrade

print_success "done"

# Install everything
print_info 'Install everything'

brew bundle --file=~/Brewfile

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
    echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
    chsh -s /usr/local/bin/zsh;
fi;

sudo easy_install -U Pygments

npm install -g spaceship-prompt gulp-cli trash-cli

print_success "done"

# install better nanorc config
# https://github.com/scopatz/nanorc
print_info 'Installing a better nano highlighting'
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

print_success "done"

print_info 'Cleanup brew'
brew cleanup

print_success "done"
# Run mac os tweaks
# cd ~; ./.macos
