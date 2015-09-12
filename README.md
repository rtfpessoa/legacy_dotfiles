# dotfiles repo

Slimmed down version of [dotfiles](https://github.com/skwp/dotfiles) edited by [rtfpessoa](https://github.com/rtfpessoa) with some changes for personal setup on for OS X.

### Summary

**Opinionated dotfile repo that will make your heart sing**

  * The best bits of all the top dotfile repos and zsh plugins curated in one place, into a simple and cohesive way of working
  * Many zsh plugins, starting with the wonderful [Prezto](https://github.com/sorin-ionescu/prezto) base, and adding a few niceties on top
  * All things are vimized: irb, postres command line, etc

### Requirements

* OS X
* Ruby
* Rake
* Git

### Setup

#### Install

To get started please run:

```
sh -c "`curl -fsSL https://raw.githubusercontent.com/rtfpessoa/dotfiles/master/dotfiles.sh`"
```

**Note:** It will automatically install all of its subcomponents. If you want to be asked
about each one, use:

```
sh -c "`curl -fsSL https://raw.githubusercontent.com/rtfpessoa/dotfiles/master/dotfiles.sh`" -s '-a'
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

#### Usage

```
usage: dotfiles.sh -c (install | update | uninstall) [options]

options:

  -a ask before execute each step
  -u [<URL>] set the url for the origin repository to install
  -d [<DEST DIR>] set the destination directory to install
    IMPORTANT: if you change the default directory, you need to set
               `DOTFILES_DIR` before the shell is loaded
               ex: export DOTFILES_DIR=/Users/me/.merc
  -f force the installation on update
```

### Features

* [Homebrew](https://github.com/Homebrew/homebrew) with all the packages on `Brewfile`

* [Rbenv](https://github.com/sstephenson/rbenv) with Ruby global version setup

* Gems: [Bundler](https://github.com/bundler/bundler) and [git-up](https://github.com/aanand/git-up)

* [Powerline](https://github.com/powerline/powerline) font for OS X

* iTerm2 [Solarized](https://github.com/altercation/solarized) Colors

* [ZSH](https://github.com/zsh-users/zsh), awesome bash without having to learn anything new

* [Vim](https://github.com/vim) mode and bash style `Ctrl-R` for reverse history finder

* UP/DOWN history search with prefix matching

* `Ctrl-x,Ctrl-l` to insert output of last command

* Fuzzy matching - if you mistype a directory name, tab completion will fix it

* [fasd](https://github.com/clvv/fasd) integration - hit `z` and partial match for recently used directory

* [Prezto](http://github.com/sorin-ionescu/prezto) - the power behind YADR's zsh

* [Tmux](https://github.com/tmux/tmux) with optimized configuration and powerline status

* [Git](https://github.com/git/git) with proper `.gitconfig` and `.gitignore`

* Fixed OS X keyboard UK layout for external keyboard (tested with [Code Keyboard](https://codekeyboards.com/))

* Zsh and Bash simple powerline themes with git status and rebase state

* Other personal tweaks and aliases

### Configure

#### Bins

Add your binaries to `.gitmodules` or manually on `shells/bins` and they will be linked to `$HOME/.bins`

#### Default shell settings

Change `shells/sources/rtfpessoa.sh` to your own settings, like default programs, personal alias, etc

#### Prezto

To override prezto configs edit the files on `zsh/overrides` and they will replace the one in the prezto official repo

#### Zsh/Bash

Both shells have some default configs in the dirs `zsh/*` and `bash/*` that you can edit

#### Others programs

If you look in the root folder you will find other configs you can customize

### Contribute

Any suggestions or improvements should be just send a pull request and it will be evaluated.

If you just want to have your own settings fork this project and customize as you wish.
