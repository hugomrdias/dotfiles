# Hugo Dias's Dotfiles

This is a collection of dotfiles and scripts I use for customizing OS X to my liking and setting up the software development tools I use on a day-to-day basis. They should be cloned to your home directory so that the path is `~/dotfiles/`. The included setup script creates symlinks from your home directory to the files which are located in `~/dotfiles/`.

The setup script is smart enough to back up your existing dotfiles into a `~/dotfiles_old/` directory if you already have any dotfiles of the same name as the dotfile symlinks being created in your home directory.

## Features

- Handy [binary scripts](bin/)
- Git aliases
- zsh aliases
- Brewfile
- Sensible [OS X defaults](.macos)
- [Install script](install.sh) to install everything brew, npm, etc..
- [Setup script](setup.sh)

## Installation

```sh
$ git clone https://github.com/hugomrdias/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ chmod +x setup.sh
$ ./setup.sh
```

## Remotely install using curl

Alternatively, you can install this into `~/dotfiles` remotely without Git using curl:

```sh
sh -c "`curl -fsSL https://raw.github.com/hugomrdias/dotfiles/master/remote-setup.sh`"
```

Or, using wget:

```sh
sh -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/hugomrdias/dotfiles/master/remote-setup.sh`"
```

## Customize

### Local Settings

The dotfiles can be easily extended to suit additional local
requirements by using the following files:

#### `~/.zsh.local`

If the `~/.zsh.local` file exists, it will be automatically sourced
after all the other [shell related files](shell), thus, allowing its
content to add to or overwrite the existing aliases, settings, PATH,
etc.

#### `~/.gitconfig.local`

If the `~/.gitconfig.local` file exists, it will be automatically
included after the configurations from [`~/.gitconfig`](.gitconfig), thus, allowing
its content to overwrite or add to the existing `git` configurations.

**Note:** Use `~/.gitconfig.local` to store sensitive information such
as the `git` user credentials, e.g.:

```sh
[user]
  name = Hugo Dias
  email = john@example.com
```

## Sensible macOS Defaults

My favorite part of this repo is the [.macos](.macos) script for macOS.

```bash
./.macos
```
## gpg and YubiKey
- [Guide](https://github.com/drduh/YubiKey-Guide)
- [gpg-agent.conf](https://github.com/drduh/YubiKey-Guide#create-configuration)
- [gpg.conf](https://github.com/drduh/YubiKey-Guide#using-keys)
  - uncomment `keyserver hkps://keys.openpgp.org` and run `gpg --recv <KEYID>`

## Resources

I actively watch the following repositories and add the best changes to this repository:

- [Setup Git GPG auto sign](https://gist.github.com/hugomrdias/0092a533d7bd87cadd0647f1985d6ca5)
- [GitHub ❤ ~/](https://dotfiles.github.io/)
- [Nick Plekhanov dotfiles](https://github.com/nicksp/dotfiles)
- [Mathias’s dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Nicolas Gallagher’s dotfiles](https://github.com/necolas/dotfiles)
- [Cătălin’s dotfiles](https://github.com/alrra/dotfiles)
- [Paul's dotfiles](https://github.com/paulirish/dotfiles)
- [Jacob Gillespie’s dotfiles](https://github.com/jacobwg/dotfiles)
- [remy's cli improved](https://remysharp.com/2018/08/23/cli-improved)

## Mac OS

### Remove Siri from the touchbar

- Keyboard preferences > Customise Control Strip

### Avoid delays in terminal cmds

- Add iTerm to Security & Privacy > Privacy > Developer Tools

### Import gpg from keybase

https://luispuerto.net/blog/2017/11/04/installing-pgp-signing-for-git-on-macos/

```bash
keybase pgp export | gpg --import
keybase pgp export --secret | gpg --import --allow-secret-key-import --no-tty --batch --yes
echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
```

## License

The code is available under the [MIT license](LICENSE).
