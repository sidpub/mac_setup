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
if [[ ! $variable ]]; then
    ssh-keygen -t rsa
    echo "SSH Generated at $HOME/.ssh"
else
    cp -R $1 $HOME/.ssh
    echo "SSH copied to $HOME/.ssh"
fi

# Configuring Vim
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vimrc_path="$HOME/.vim_runtime/vimrcs"
if [[ -d "$vimrc_path" ]]; then
    cp plugins_ext_config.vim $vimrc_path/plugins_ext_config.vim
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

vim +PluginInstall +qall

curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
# printf "\n\nplugins=(bgnotify colored-man-pages colorize common-aliases copyfile per-directory-history dirpersist dotenv extract git-extras globalias helm history-substring-search jsontools pj redis-cli zsh-navigation-tools)\n\n" >> "$HOME/.zshrc"
if [[ ! -d "$HOME/.dotfiles" ]]; then
   mkdir "$HOME/.dotfiles"
fi

printf 'export PATH="/usr/local/bin:$PATH"\n' >> "$HOME/.zshrc"
printf 'export JAVA_HOME="/Library/Java/Home"\n' >> "$HOME/.zshrc"
printf 'eval "$(rbenv init - --no-rehash)"\n' >> "$HOME/.zshrc"
printf 'fpath=(/usr/local/share/zsh-completions $path)\n' >> "$HOME/.zshrc"
printf 'if [ "$(ls -A $HOME/.dotfiles)" ]; then\n' >> "$HOME/.zshrc"
printf 'for f in ~/.dotfiles/*; do source $f; done\n' >> "$HOME/.zshrc"
printf 'fi\n' >> "$HOME/.zshrc"
chsh -s /bin/zsh
cd $HOME/Downloads && curl -O https://d11yldzmag5yn.cloudfront.net/prod/4.1.23501.0416/zoomusInstaller.pkg
sudo /usr/sbin/installer -pkg /Users/siddarthramaswamy/Downloads/zoomusInstaller.pkg -target /

# Mac Modifications
defaults write com.apple.Dock orientation -string right
defaults write com.apple.dock tilesize -int 16;
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 128;
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock mineffect -string 'genie'
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Maximize"
defaults write com.apple.dock launchanim -bool true
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Slack.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTunes.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/zoom.us.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Atom.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Sketch.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Postman.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Evernote.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
killall Dock
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
