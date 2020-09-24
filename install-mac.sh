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

# Install mas
print_info 'Install mas and update/upgrade brew'
if test ! $(which mas); then
    print_info "Installing mas..."
    brew install mas
fi

brew update
brew upgrade
brew bundle --file=~/Brewfile
brew cleanup

print_success "done"
# Run mac os tweaks
# cd ~; ./.macos
