#!/bin/bash

LNK="/media/"
FOLDER=""
USER=""
cd $LNK
USER=`ls -l | grep "\ ub" | sed -e 's/.*\ \(ub.*-.*e$\)/\1/g'`
LNK+=$USER && LNK+="/"

P_LIB=$LNK
cd "$P_LIB" && INTER="Arch/" && P_LIB+="$INTER" && cd "$P_LIB"
P_LIB+="`ls -l | grep "0p" | sed -e 's/.*\ \(0p.*$\)/\1/g'`"

cd
sudo apt remove --purge -y firefox
sudo apt update
sudo apt install firefox
cp -R $P_LIB/mozilla/.mozilla ~/
sudo apt install -y zsh git
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

passwd
sudo passwd

chsh -s `which zsh`

git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

git clone https://github.com/gabrielelana/awesome-terminal-fonts
mkdir ~/.fonts && cp awesome-terminal-fonts/build/*.ttf ~/.fonts && cp awesome-terminal-fonts/build/*.sh ~/.fonts && fc-cache -fv ~/.fonts
sed -i 's/PragmataPro/Inconsolata+Awesome/g' ~/awesome-terminal-fonts/config/10-symbols.conf
mkdir -p ~/.config/fontconfig/conf.d && cp ~/awesome-terminal-fonts/config/10-symbols.conf ~/.config/fontconfig/conf.d && rm -rf ~/awesome-terminal-fonts

# --------------------------------------------------------------------

rm -rf ~/.zshrc
echo "export PATH=$HOME/bin:/usr/local/bin:$PATH
source ~/.fonts/*.sh
POWERLEVEL9K_MODE='awesome-fontconfig'

export ZSH=\"/home/ubuntu-gnome/.oh-my-zsh\"
ZSH_THEME=\"powerlevel9k/powerlevel9k\"

#POWERLEVEL9K_CUSTOM_CONTEXT=\"echo -n '\uF109'\"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE=\"true\"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context os_icon dir root_indicator dir_writable vcs) 
POWERLEVEL9K_TIME_BACKGROUND='blue'
POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='teal'
POWERLEVEL9K_CONTEXT_TEMPLATE=\"\uF109\"
POWERLEVEL9K_OS_ICON_BACKGROUND=\"white\"
POWERLEVEL9K_OS_ICON_FOREGROUND=\"blue\"
POWERLEVEL9K_DIR_HOME_FOREGROUND=\"white\"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=\"white\"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=\"white\"
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
plugins=(
  git
)

source \"\$ZSH/oh-my-zsh.sh\" " >> ~/.zshrc

# https://github.com/agnoster/agnoster-zsh-theme/blob/master/agnoster.zsh-theme
# ----------------------------------------------------------------------

sudo apt install -y curl libncurses5-dev python3-dev build-essential libfontconfig1 python3-pip chrome-gnome-shell pkg-config autoconf software-properties-common python-software-properties subversion

svn checkout https://github.com/ryanoasis/nerd-fonts/trunk/patched-fonts/Inconsolata
cp ~/Inconsolata/complete/Inconsolata\ Nerd\ Font\ Complete.otf ~/.fonts && rm -rf ~/Inconsolata

wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
[ -d "~/.local/share/fonts/" ] || mkdir -p ~/.local/share/fonts/
mv PowerlineSymbols.otf ~/.local/share/fonts/
fc-cache -vf ~/.local/share/fonts/
[ -d "~/.config/fontconfig/conf.d" ] || mkdir -p ~/.config/fontconfig/conf.d
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

git clone https://github.com/vim/vim.git
cd vim
./configure --with-features=huge --enable-multibyte --enable-python3interp=yes --with-python3-config-dir=/usr/lib/python3.5/config --enable-cscope --prefix=/usr/local
cd src
make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
sudo make install
cd ../..
rm -rf ~/vim

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

wget  https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2-Linux-x86_64.tar.gz
tar -xvzf cmake* 
mv cmake-3.15.2-Linux-x86_64 cmake
sudo mv cmake/ /opt
sudo ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
rm -rf cmake-3.15.2*.tar.gz

pip3 install --user neovim

LNK="/media/" && FOLDER="" && USER=""
cd $LNK
USER=`ls -l | grep "\ ub" | sed -e 's/.*\ \(ub.*-.*e$\)/\1/g'`
LNK+=$USER && LNK+="/" && INTER="Arch/" && LNK+=$INTER && cd $LNK && FOLDER=$LNK && FOLDER+=`ls -l | grep "0p" | sed -e 's/.*\ \(0p.*$\)/\1/g'`
cp $FOLDER/03/0DESKTOP/dotfiles/.vimrc ~/
ln -s $FOLDER/software/.vim ~/

cd /
sudo chown $USER:$USER $LNK
cd $LNK
sudo chown $USER:$USER $USER

cd

wget https://github.com/gnunn1/tilix/releases/download/1.9.3/tilix.zip
sudo unzip tilix.zip -d /
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
rm -rf ~/tilix.zip

firstRow="if [ \"\$TILIX_ID\" ] || [ \"\$VTE_VERSION\" ]; then" && secondRow="\        source /etc/profile.d/vte.sh" && thirdRow="fi"

sed -i -e "\$a$firstRow" -e "\$a$secondRow" -e "\$a$thirdRow" $HOME"/.zshrc"

sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh

cp $FOLDER/software/tilix.dconf .
dconf load /com/gexperts/Tilix/ < tilix.dconf
rm -rf ~/tilix.dconf



git clone https://github.com/lassekongo83/zuki-themes
cd zuki-themes/ && git checkout -b 3.18 origin/3.18 && git pull && cd 
mkdir ~/.themes
mv ~/zuki-themes/Zukitre/ ~/.themes && mv ~/zuki-themes/Zuki-shell ~/.themes && rm -rf ~/zuki-themes

gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh 
./configure
make
sudo make install
cd

sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

wget https://bintray.com/probono/AppImages/download_file?file_path=VLC-2.2.3.glibc2.12-x86_64.AppImage
chmod +x VLC-2.2.3.glibc2.12-x86_64.AppImage

tracker daemon -t
[ -d "~/.config/autostart" ] || mkdir -p ~/.config/autostart
cd ~/.config/autostart
cp -v /etc/xdg/autostart/tracker-* ./
for FILE in `ls`; do echo Hidden=true >> $FILE; done
rm -rf ~/.cache/tracker ~/.local/share/tracker
cd

sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt install libstdc++6


P_CLANG="/media/ubuntu-gnome/" && cd "$P_CLANG" && INTER="Arch/" && P_CLANG+="$INTER"
P_CLANG="$LNK" cd "$P_CLANG" && cd ..
P_CLANG+="`ls -l "$INTER" | grep clang | sed -e 's/.*\ \([a-z]\{5\}$\)/\1/g'`"
echo "export PATH=$P_CLANG/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/bin/:\$PATH" >> ~/.zshrc
echo "export LD_LIBRARY_PATH=$P_CLANG/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/lib/:\$LD_LIBRARY_PATH" >> ~/.zshrc
cd

ln -s $FOLDER/installation/.rustup .

echo "export PATH=$FOLDER/software/.cargo/env/:\$PATH" >> ~/.zshrc

echo "export PATH=$FOLDER/software/.cargo/env/:\$PATH" >> ~/.profile
export "PATH=\"$FOLDER/installation/bin:\$PATH\"" >> ~/.profile


# add .cquery file in project root folder:
echo "%clang
%c -std=gnu11
%cpp -std=gnu++14
-pthread

# Includes
-I$LNK/prog/cquery/third_party
-I/usr/include
# -I/work/cquery/another_third_party
# -I space_is_not_allowed" >> ~/.cquery

# FOR A COLD INSTALLATION OF RUST:
# CONFIGURE CLANG & LLVM FIRST:
clang --version
llc --version
RUSTUP_HOME=$FOLDER/installation CARGO_HOME=$FOLDER/installation bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y'
rustup default stable
# LOG OUT & LOG BACK IN
mv ~/.rustup $FOLDER/installation
ln -s $FOLDER/installation/.rustup .
rustc --version


cd / 

LNK="/media/" && FOLDER="" && USER=""
cd $LNK
USER=`ls -l | grep "\ ub" | sed -e 's/.*\ \(ub.*-.*e$\)/\1/g'`

cd /
sudo chmod a+w $LNK
cd $LNK

LNK+=$USER && LNK+="/"
ls -l
sudo chmod a+r $USER
sudo chmod a+wx $USER
ls -l

INTER="Arch/" && LNK+=$INTER && cd $LNK && FOLDER=$LNK && FOLDER+=`ls -l | grep "0p" | sed -e 's/.*\ \(0p.*$\)/\1/g'`
cd /
cd $LNK
sudo chmod a+w $FOLDER

cd /tmp
sudo chown $USER:$USER tmp

exit 0

python3 import neovim

