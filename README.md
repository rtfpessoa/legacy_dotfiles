# dotfiles repo

Slimmed down version of [dotfiles](https://github.com/skwp/dotfiles)
edited by [rtfpessoa](https://github.com/rtfpessoa)
with some changes for personal setup on Mac OS and Ubuntu.

### Summary

**Opinionated dotfile repo that will make your heart sing**

### Requirements

* Curl
* Ruby
* Rake
* Git

### Setup

#### Install

To get started please run:

```
bash -c "`curl -fsSL https://raw.githubusercontent.com/rtfpessoa/dotfiles/master/dotfiles.sh`" -s -c install
```

> The installation directory is `$HOME/.$(whoami)rc`

#### Upgrade

Upgrading is easy.

```
./dotfiles.sh -c update
```

#### Uninstall

Uninstalling is easy.

```
./dotfiles.sh -c uninstall
```

> NOTE: This only removes the main shell files symlinked by the installer.

##### After uninstall

  * Uninstall homebrew and all its dependencies
  * MacOS
    * Revert Terminal settings
    * Revert iTerm settings
    * Remove extra keyboard layouts from '/Library/Keyboard Layouts'
  * Ubuntu
    * Remove the installed packages
      * Check 'install_ubuntu_packages' in Rakefile
      * Check 'install_oracle_jdk8_ubuntu' in Rakefile

#### Usage

```
usage: dotfiles.sh -c (install | update | uninstall) [options]

options:

  -a ask before execute each step
  -u [<URL>] set the url for the origin repository to install
  -d [<DEST_PATH>] set the destination directory to install
    IMPORTANT: if you change the default directory, you need to set
               `DOTFILES` before the shell is loaded
               ex: export DOTFILES=/Users/me/.merc
  -f force the installation on update
```

### Features

* [Homebrew](https://github.com/Homebrew/homebrew) with all the packages on `Brewfile`

* [Rbenv](https://github.com/sstephenson/rbenv) with Ruby global version setup

* Gems: [Bundler](https://github.com/bundler/bundler) and [git-up](https://github.com/aanand/git-up)

* [Powerline](https://github.com/powerline/powerline) font for OS X

* iTerm [Solarized](https://github.com/altercation/solarized) Colors

* [Vim](https://github.com/vim) mode and bash style `Ctrl-R` for reverse history finder

* UP/DOWN history search with prefix matching

* `Ctrl-x,Ctrl-l` to insert output of last command

* [Tmux](https://github.com/tmux/tmux) with optimized configuration and powerline status

* [Git](https://github.com/git/git) with proper `.gitconfig` and `.gitignore`

* Fixed OS X keyboard UK layout for external keyboard (tested with [Code Keyboard](https://codekeyboards.com/))

* Fish and Bash simple powerline themes with git status and rebase state

* Other personal tweaks and aliases

### Configure

#### Bins

Add your binaries to `.gitmodules` or manually on `shells/bins` and they will be linked to `$HOME/.bins`

#### Default shell settings

Change `shells/posix/rtfpessoa.sh` and `shells/fish/conf.d/rtfpessoa.fish` to your own settings,
like default programs, personal alias, etc

#### Fish/Bash

Both shells have some default configs in the dirs `fish/*` and `bash/*` that you can edit

#### Others programs

If you look in the root folder you will find other configs you can customize

### Contribute

Any suggestions or improvements should be just send a pull request and it will be evaluated.

If you just want to have your own settings fork this project and customize as you wish.
