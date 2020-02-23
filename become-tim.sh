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
sudo apt install -y git curl tmux vim sakura zsh \
	tint2 openbox lightdm feh feh gtk-theme-switch gtk2-engines \
	conky

### install and configure visual studio code
curl --location https://go.microsoft.com/fwlink/?LinkID=760868 -o $__dir/vscode.deb
sudo apt install $__dir/vscode.deb
code --install-extension vscodevim.vim
cp $__dir/config/conffiles/code_settings.json ~/.config/Code/User/settings.json
 
### copy out the rest of the config files
__confs="$__dir/config/conffiles/"
cp $__confs/bashrc ~/.bashrc
cp $__confs/conkyrc ~/.conkyrc
cp $__confs/tmux.conf ~/.tmux.conf
cp $__confs/zshrc ~/.zshrc
cp $__confs/xinitrc ~/.xinitrc
mkdir -p ~/.config/sakura
cp $__confs/sakura.conf ~/.config/sakura.conf

mkdir -p ~/.config/openbox
cp $__confs/openbox-autostart ~/.config/openbox/autostart
cp $__confs/openbox-rc.xml ~/.config/openbox/rc.xml
cp $__confs/openbox-menu.xml ~/.config/openbox/menu.xml

### configure defaults
sudo update-alternatives --set x-terminal-emulator /usr/bin/sakura
sudo update-alternatives --set x-session-manager /usr/bin/openbox-session
sudo update-alternatives --set x-window-manager /usr/bin/openbox
chsh --shell /usr/bin/zsh $USER
sudo dpkg-reconfigure lightdm

rm -rf $__dir

