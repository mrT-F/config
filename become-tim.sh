#!/bin/sh
# become timmy on ubuntu

# Add a newline to whatever you're printing.
# $1: What you're printing.
printfln () {
    printf "$1\n"
}

# Visible section header
# $1: The message you want printed
section_print () {
    printfln "#########################################"
    printfln "#"
    printfln "# $1"
    printfln "#"
    printfln "#########################################"
}


__dir=$(mktemp -d -t bt-XXXXX)
section_print "Doing work in $(realpath $__dir)"


## clone this repo to the tempdir - we'll use the conffiles.
git clone https://github.com/mrT-F/config.git $__dir/config/

# apt install what we mean, but this script isn't
# really meant to manage packages,
# something else should do that.
sudo apt install -y git curl tmux vim sakura zsh tint2 openbox

### install and configure visual studio code
curl --location https://go.microsoft.com/fwlink/?LinkID=760868 -o $__dir/vscode.deb
sudo apt install $__dir/vscode.deb
code --install-extension vscodevim.vim
cp $__dir/config/conffiles/code_settings.json ~/.config/Code/User/settings.json
 
### copy out the rest of the config files
__confs="$__dir/config/conffiles/"
cp $__confs/sakura.conf ~/.config/sakura/sakura.conf
cp $__confs/bashrc ~/.bashrc
cp $__confs/conkyrc ~/.conkyrc
cp $__confs/tmux.conf ~/.tmux.conf
cp $__confs/zshrc ~/.zshrc

### configure defaults
sudo update-alternatives --set x-terminal-emulator /usr/bin/sakura
chsh --shell /usr/bin/zsh $USER

rm -rf $__dir

