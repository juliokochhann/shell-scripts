function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

echo -n "Fetch configuration files..."

git clone --bare https://github.com/kcjulio/dotfiles.git $HOME/.cfg --quiet

echo " done"

echo -n "Check out files..."

err=$(config checkout 2>&1)

if [ -n "$err" ]
    then
        echo -n " Backup pre-existing dotfiles..."

        mkdir -p $HOME/.config-backup
        echo -e $err | grep -Eo "\.\w+" | xargs -I{} mv $HOME/{} $HOME/.config-backup/{}

        config checkout
fi

echo " done"

config config status.showUntrackedFiles no

echo -n "Install Bash-Git-Prompt..."

git clone https://github.com/magicmonty/bash-git-prompt.git $HOME/.bash-git-prompt --depth=1 --quiet

echo " done"

echo -n "Install gnome-terminal Dracula theme..."
# Set default profile name to 'Dracula'
id=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")

gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$id/ visible-name 'Dracula'

git clone https://github.com/dracula/gnome-terminal.git $HOME/.gnome-terminal --quiet

/bin/bash $HOME/.gnome-terminal/install.sh --scheme=Dracula --profile 'Dracula' --skip-dircolors

echo " done"

echo -n "Install xfce4-terminal Dracula theme..."

git clone https://github.com/dracula/xfce4-terminal.git $HOME/.xfce4-terminal --quiet

mkdir -p $HOME/.local/share/xfce4/terminal/colorschemes

cp $HOME/.xfce4-terminal/Dracula.theme $HOME/.local/share/xfce4/terminal/colorschemes

echo "Setup complete!"
