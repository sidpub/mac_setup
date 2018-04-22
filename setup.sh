#!/bin/bash

ssh_path=$1

# Installing Command Line Tools
xcode-select -p
if [[ $? != 0 ]]; then
  echo "Please install command line tools to continue"
  exit
fi

# Installing Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
if [[ $? != 0 ]]; then
  echo "Issue installing homebrew"
  exit
fi

brew update
brew bundle --file=Brewfile
brew cask cleanup
export PATH="/usr/local/bin:$PATH"

# Configure Ruby
ruby_version="$(rbenv install -l | grep -v - | tail -1 | sed -e 's/^ *//')"
val "$(rbenv init -)"
if ! rbenv versions | grep -Fq "$ruby_version"; then
  RUBY_CONFIGURE_OPTS=--with-openssl-dir=/usr/local/opt/openssl rbenv install -s "$ruby_version"
fi
rbenv global "$ruby_version"

# Install NPM Packages
npm install vtop -g --silent
npm install eslint -g --silent
npm install gulp-cli -g --silent
npm install react-native-cli -g --silent
npm install artillery -g --silent

# Setting Up SSH
if [[ ! $variable ]]
    ssh-keygen -t rsa
    echo "SSH Generated at $HOME/.ssh"
else
    cp -R $1 $HOME/.ssh
    echo "SSH copied to $HOME/.ssh"
fi

# Configuring Vim
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
if if [ -d "$HOME/.vim_rumtime/vimrcs/plugins_ext_config.vim" ]; then
    cp plugins_ext_config.vim $HOME/.vim_rumtime/vimrcs/plugins_ext_config.vim
else
    echo "We were unable to copy the plugin configuration"
fi
printf "\nset nocompatible\n" >> "$HOME/.vimrc"
printf "filetype off\n" >> "$HOME/.vimrc"
printf "set rtp+=~/.vim/bundle/Vundle.vim\n" >> "$HOME/.vimrc"
printf "call vundle#begin()\n" >> "$HOME/.vimrc"
printf "Plugin 'VundleVim/Vundle.vim'\n" >> "$HOME/.vimrc"
printf "Plugin 'Valloric/YouCompleteMe'\n" >> "$HOME/.vimrc"
printf "Plugin 'tomasr/molokai'\n" >> "$HOME/.vimrc"
printf "Plugin 'vim-syntastic/syntastic'\n" >> "$HOME/.vimrc"
printf "Plugin 'vim-airline/vim-airline'\n" >> "$HOME/.vimrc"
printf "Plugin 'fatih/vim-go'\n" >> "$HOME/.vimrc"
printf "Plugin 'honza/vim-snippets'\n" >> "$HOME/.vimrc"
printf "Plugin 'mileszs/ack.vim'\n" >> "$HOME/.vimrc"
printf "Plugin 'Shougo/neocomplete.vim'\n" >> "$HOME/.vimrc"
printf "Plugin 'tomtom/tlib_vim'\n" >> "$HOME/.vimrc"
printf "Plugin 'easymotion/vim-easymotion'\n" >> "$HOME/.vimrc"
printf "Plugin 'thoughtbot/vim-rspec'\n" >> "$HOME/.vimrc"
printf "Plugin 'ctrlpvim/ctrlp.vim'\n" >> "$HOME/.vimrc"
printf "Plugin 'scrooloose/nerdtree'\n" >> "$HOME/.vimrc"
printf "Plugin 'MarcWeber/vim-addon-mw-utils'\n" >> "$HOME/.vimrc"
printf "Plugin 'tpope/vim-fugitive'\n" >> "$HOME/.vimrc"
printf "Plugin 'garbas/vim-snipmate'\n" >> "$HOME/.vimrc"
printf "Plugin 'flazz/vim-colorschemes'\n\n" >> "$HOME/.vimrc"
printf "call vundle#end()\n" >> "$HOME/.vimrc"
printf "filetype plugin indent on\n\n" >> "$HOME/.vimrc"
printf "source ~/.vim_runtime/vimrcs/basic.vim\n" >> "$HOME/.vimrc"
printf "source ~/.vim_runtime/vimrcs/filetypes.vim\n" >> "$HOME/.vimrc"
printf "source ~/.vim_runtime/vimrcs/plugins_ext_config.vim\n" >> "$HOME/.vimrc"
printf "source ~/.vim_runtime/vimrcs/extended.vim\n" >> "$HOME/.vimrc"

# Configuring ZSH
# Comment out Plugins and necessary aliases
# Appending to zshrc
#if [ ! -d "$HOME/.dotfiles" ]; then
#    mkdir "$HOME/.dotfiles"
#fi
#'export PATH="/usr/local/bin:$PATH"'
#'eval "$(rbenv init - --no-rehash)"'
#for f in ~/.dotfiles/*; do source $f; done
