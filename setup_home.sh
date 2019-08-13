#!/bin/bash

P_LIB="/media/ubuntu-gnome/"
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

cp /media/ubuntu-gnome/Arch/0post_crash/03/0DESKTOP/dotfiles/.vimrc ~/
ln -s /media/ubuntu-gnome/Arch/0post_crash/software/.vim ~/

cd /
sudo chown ubuntu-gnome:ubuntu-gnome /media
cd /media
sudo chown ubuntu-gnome:ubuntu-gnome ubuntu-gnome

cd

wget https://github.com/gnunn1/tilix/releases/download/1.9.3/tilix.zip
sudo unzip tilix.zip -d /
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
rm -rf ~/tilix.zip

firstRow="if [ \"\$TILIX_ID\" ] || [ \"\$VTE_VERSION\" ]; then" && secondRow="\        source /etc/profile.d/vte.sh" && thirdRow="fi"

sed -i -e "\$a$firstRow" -e "\$a$secondRow" -e "\$a$thirdRow" $HOME"/.zshrc"

sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh

cp /media/ubuntu-gnome/Arch/0post_crash/software/tilix.dconf .
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


P_CLANG="/media/ubuntu-gnome/" && cd "$P_CLANG" && INTER="Arch/" && P_CLANG+="$INTER"
P_CLANG+="`ls -l "$INTER" | grep clang | sed -e 's/.*\ \([a-z]\{5\}$\)/\1/g'`"
echo "export PATH=$P_CLANG/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/bin/:\$PATH" >> ~/.zshrc
echo "export LD_LIBRARY_PATH=$P_CLANG/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/lib/:\$LD_LIBRARY_PATH" >> ~/.zshrc
cd

#curl https://sh.rustup.rs -sSf | sh
#source $HOME/.cargo/env

#CARGO_HOME="/media/ubuntu-gnome/Arch/0post_crash/installation" RUSTUP_HOME="/media/ubuntu-gnome/Arch/0post_crash/installation" ./rustup_init.sh

#ln -s /media/ubuntu-gnome/Arch/0post_crash/software/.cargo .
#ln -s /media/ubuntu-gnome/Arch/0post_crash/software/.rustup .
#echo "export PATH=/media/ubuntu-gnome/Arch/0post_crash/software/.cargo/env/:\$PATH" >> ~/.zshrc

#RUSTUP_HOME=/media/ubuntu-gnome/Arch/0post_crash/installation CARGO_HOME=/media/ubuntu-gnome/Arch/0post_crash/installation bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y'
#rustup default stable

#cd
#ln -s /media/ubuntu-gnome/Arch/0post_crash/software/.vim .
#ln -s /media/ubuntu-gnome/Arch/0post_crash/software/.themes .

# curl --compressed -o- -L https://yarnpkg.com/install.sh | bash




ln -s /media/ubuntu-gnome/Arch/0post_crash/installation/.rustup .

echo "export PATH=/media/ubuntu-gnome/Arch/0post_crash/software/.cargo/env/:\$PATH" >> ~/.zshrc

echo "export PATH=/media/ubuntu-gnome/Arch/0post_crash/software/.cargo/env/:\$PATH" >> ~/.profile
export "PATH=\"/media/ubuntu-gnome/Arch/0post_crash/installation/bin:\$PATH\"" >> ~/.profile

exit 0



# FOR A COLD INSTALLATION OF RUST:
# CONFIGURE CLANG & LLVM FIRST:
clang --version
llc --version
RUSTUP_HOME=/media/ubuntu-gnome/Arch/0post_crash/installation CARGO_HOME=/media/ubuntu-gnome/Arch/0post_crash/installation bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y'
rustup default stable
# LOG OUT & LOG BACK IN
mv ~/.rustup /media/ubuntu-gnome/Arch/0post_crash/installation
ln -s /media/ubuntu-gnome/Arch/0post_crash/installation/.rustup .
rustc --version

python3 import neovim


sudo apt install -y build-essential libbz2-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev tk-dev
sudo apt install -y libpng-dev libfreetype6-dev
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

echo "export PATH=\"\$HOME/.pyenv/bin:\$PATH\"
eval \"\$(pyenv init -)\"
eval \"\$(pyenv virtualenv-init -)\"" >> ~/.zshrc

pyenv install 3.6.1
pyenv virtualenv 3.6.1 general
pyenv global general


wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz
tar -xvzf Python-3.6.1.tgz
cd Python-3.6.1
./configure
make
sudo make altinstall


pip3 install --user pynvim
pip3 install --user --upgrade pynvim

cd ~/.vim/plugged/vim-airline/autoload/airline
sed -i -e 's/df5f00/0087af/' -e 's/166/31/' themes.vim 


[LC] Failed to start language server (["/media/ubuntu-gnome/Arch/prog/cquery", "--log-file=/tmp/cq.log"]): Permission denied (os error 13
cd / 
sudo chmod a+w media
cd /media
ls -l
sudo chmod a+r ubuntu-gnome
sudo chmod a+wx ubuntu-gnome
ls -l
cd ubuntu-gnome/Arch
sudo chmod a+w 0post_crash


[LC] Failed to start language server (["/media/ubuntu-gnome/Arch/prog/cquery", "--log-file=/tmp/cq.log"]): Permission denied (os error 13)

cd /tmp
sudo chown ubuntu-gnome:ubuntu-gnome tmp


pour eviter l\'erreur:
/media/ubuntu-gnome/Arch/prog/cquery/build >$ ./cquery --check ~/cquery/src/command_line.cc
./cquery: /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version \`GLIBCXX_3.4.22\' not found (required by ./cquery)


$ sudo add-apt-repository ppa:ubuntu-toolchain-r/test
$ sudo apt update
$ sudo apt install libstdc++6

$ cd /media/ubuntu-gnome/Arch/prog/cquery/build
$ ./cquery --check ../src/command_line.cc


changer .vimrc pour le chemin complet a cquery (l\'executable):
let g:LanguageClient_serverCommands = {
    \ 'cpp': ['/media/ubuntu-gnome/Arch/prog/cquery/build/cquery', '--log-file=/tmp/cq.log'],
    \ 'c': ['/media/ubuntu-gnome/Arch/prog/cquery/build/cquery'

de /tmp/LanguageServer.log:
Failed to normalize /home/ubuntu-gnome/fm/build
(   1.407s) [querydb      ]        project.cc:512   | cquery has no clang arguments. Considering adding a .cquery file or c_cpp_properties.json or compile_commands.json. See the cquery README for more information.

add .cquery file in project root folder:
%clang
%c -std=gnu11
%cpp -std=gnu++14
-pthread

# Includes
-I/media/ubuntu-gnome/Arch/prog/cquery/third_party
-I/usr/include
# -I/work/cquery/another_third_party
# -I space_is_not_allowed


[LC] 'Vim(let):E28: No such highlight group name: ALEError'
cd ~/.vim
grep -orn "ALEError"




_________________________________________________________________________________________________________




/media/ubuntu-gnome/Arch/prog/cquery/build $   ./cquery --check ../src/command_line.cc
(   0.000s) [main thread  ]   command_line.cc:438   | Running --check
(   0.000s) [main thread  ]          utils.cc:298   | Reading /media/ubuntu-gnome/Arch/prog/cquery/src/command_line.cc
(   0.000s) [main thread  ]   command_line.cc:451   | Using path /media/ubuntu-gnome/Arch/prog/cquery/src/command_line.cc
(   0.000s) [main thread  ]        project.cc:69    | Failed to normalize /media/ubuntu-gnome/Arch/prog/cquery/build/build
(   0.000s) [main thread  ]        project.cc:612   | Trying to load /media/ubuntu-gnome/Arch/prog/cquery/build/build/compile_commands.json
(   0.000s) [main thread  ]        project.cc:619   | Trying to load /media/ubuntu-gnome/Arch/prog/cquery/build/compile_commands.json
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/siphash.cc
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/doctest
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/loguru
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/msgpack-c/include
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/pugixml/src
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/rapidjson/include
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/sparsepp
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/reproc/include/c
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/reproc/include/cpp
(   0.004s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/build/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-14.04/include
(   0.004s) [main thread  ]clang_system_include_extractor.cc:76    | Using compiler drivers /usr/bin/c++, /media/ubuntu-gnome/Arch/prog/cquery/build/cquery-clang, clang++, g++
(   0.007s) [main thread  ]       platform.cc:149   | Executed "/usr/bin/c++ --version"
(   0.007s) [main thread  ]clang_system_include_extractor.cc:88    | Running /usr/bin/c++ -E -x c++ - -v
(   0.013s) [main thread  ]       platform.cc:149   | Executed "/usr/bin/c++ -E -x c++ - -v"
(   0.013s) [main thread  ]clang_system_include_extractor.cc:93    | Output:
# 1 "<stdin>"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "<stdin>"
Using built-in specs.
COLLECT_GCC=/usr/bin/c++
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu 5.4.0-6ubuntu1~16.04.11' --with-bugurl=file:///usr/share/doc/gcc-5/README.Bugs --enable-languages=c,ada,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr --program-suffix=-5 --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-vtable-verify --enable-libmpx --enable-plugin --with-system-zlib --disable-browser-plugin --enable-java-awt=gtk --enable-gtk-cairo --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-5-amd64/jre --enable-java-home --with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-5-amd64 --with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-5-amd64 --with-arch-directory=amd64 --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --enable-objc-gc --enable-multiarch --disable-werror --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib --with-tune=generic --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.11) 
COLLECT_GCC_OPTIONS='-E' '-v' '-shared-libgcc' '-mtune=generic' '-march=x86-64'
 /usr/lib/gcc/x86_64-linux-gnu/5/cc1plus -E -quiet -v -imultiarch x86_64-linux-gnu -D_GNU_SOURCE - -mtune=generic -march=x86-64 -fstack-protector-strong -Wformat -Wformat-security
ignoring duplicate directory "/usr/include/x86_64-linux-gnu/c++/5"
ignoring nonexistent directory "/usr/local/include/x86_64-linux-gnu"
ignoring nonexistent directory "/usr/lib/gcc/x86_64-linux-gnu/5/../../../../x86_64-linux-gnu/include"
#include "..." search starts here:
#include <...> search starts here:
 /usr/include/c++/5
 /usr/include/x86_64-linux-gnu/c++/5
 /usr/include/c++/5/backward
 /usr/lib/gcc/x86_64-linux-gnu/5/include
 /usr/local/include
 /usr/lib/gcc/x86_64-linux-gnu/5/include-fixed
 /usr/include/x86_64-linux-gnu
 /usr/include
End of search list.
COMPILER_PATH=/usr/lib/gcc/x86_64-linux-gnu/5/:/usr/lib/gcc/x86_64-linux-gnu/5/:/usr/lib/gcc/x86_64-linux-gnu/:/usr/lib/gcc/x86_64-linux-gnu/5/:/usr/lib/gcc/x86_64-linux-gnu/
LIBRARY_PATH=/usr/lib/gcc/x86_64-linux-gnu/5/:/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/:/usr/lib/gcc/x86_64-linux-gnu/5/../../../../lib/:/lib/x86_64-linux-gnu/:/lib/../lib/:/usr/lib/x86_64-linux-gnu/:/usr/lib/../lib/:/usr/lib/gcc/x86_64-linux-gnu/5/../../../:/lib/:/usr/lib/
COLLECT_GCC_OPTIONS='-E' '-v' '-shared-libgcc' '-mtune=generic' '-march=x86-64'
(   0.013s) [main thread  ]        project.cc:166   | Using system include directory flags
  -isystem/usr/include/c++/5
  -isystem/usr/include/x86_64-linux-gnu/c++/5
  -isystem/usr/include/c++/5/backward
  -isystem/usr/lib/gcc/x86_64-linux-gnu/5/include
  -isystem/usr/local/include
  -isystem/usr/lib/gcc/x86_64-linux-gnu/5/include-fixed
  -isystem/usr/include/x86_64-linux-gnu
  -isystem/usr/include
(   0.013s) [main thread  ]        project.cc:170   | To disable this set the discoverSystemIncludes config option to false.
(   0.013s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/pugixml/src/pugixml.cpp
(   0.013s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/c_cpp_properties.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/cache_manager.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/clang_complete.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/clang_cursor.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/clang_format.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/clang_index.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/clang_indexer.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/clang_system_include_extractor.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/clang_translation_unit.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/clang_utils.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/code_complete_cache.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/command_line.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/compiler.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/diagnostics_engine.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/file_consumer.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/file_contents.cc
(   0.014s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/file_types.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/fuzzy_match.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/iindexer.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/import_manager.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/import_pipeline.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/include_complete.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/method.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/lex_utils.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/lsp.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/lsp_diagnostic.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/match.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/message_handler.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/options.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/platform_posix.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/platform_win.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/platform.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/position.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/project.cc
(   0.015s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/query_utils.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/query.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/queue_manager.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/recorder.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/semantic_highlight_symbol_cache.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/serializer.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/standard_includes.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/task.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/test.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/third_party_impl.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/threaded_queue.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/timer.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/timestamp_manager.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/type_printer.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/utils.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/work_thread.cc
(   0.016s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/working_files.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/cquery_base.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/cquery_call_hierarchy.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/cquery_callers.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/cquery_did_view.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/cquery_file_info.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/cquery_freshen_index.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/cquery_index_file.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/cquery_inheritance_hierarchy.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/cquery_vars.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/cquery_wait.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/exit.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/initialize.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/shutdown.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_code_action.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_code_lens.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_completion.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_definition.cc
(   0.017s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_did_change.cc
(   0.018s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_did_close.cc
(   0.018s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_did_open.cc
(   0.018s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_did_save.cc
(   0.018s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_document_highlight.cc
(   0.018s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_document_link.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_document_symbol.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_formatting.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_hover.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_implementation.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_range_formatting.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_references.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_rename.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_signature_help.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/text_document_type_definition.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/workspace_did_change_configuration.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/workspace_did_change_watched_files.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/workspace_execute_command.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/src/messages/workspace_symbol.cc
(   0.019s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/reproc/src/c/common.c
(   0.020s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/reproc/src/c/posix
(   0.020s) [main thread  ]clang_system_include_extractor.cc:76    | Using compiler drivers /usr/bin/cc, /media/ubuntu-gnome/Arch/prog/cquery/build/cquery-clang, clang++, g++
(   0.022s) [main thread  ]       platform.cc:149   | Executed "/usr/bin/cc --version"
(   0.022s) [main thread  ]clang_system_include_extractor.cc:88    | Running /usr/bin/cc -E -x c - -v
(   0.029s) [main thread  ]       platform.cc:149   | Executed "/usr/bin/cc -E -x c - -v"
(   0.029s) [main thread  ]clang_system_include_extractor.cc:93    | Output:
# 1 "<stdin>"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "<stdin>"
Using built-in specs.
COLLECT_GCC=/usr/bin/cc
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu 5.4.0-6ubuntu1~16.04.11' --with-bugurl=file:///usr/share/doc/gcc-5/README.Bugs --enable-languages=c,ada,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr --program-suffix=-5 --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-vtable-verify --enable-libmpx --enable-plugin --with-system-zlib --disable-browser-plugin --enable-java-awt=gtk --enable-gtk-cairo --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-5-amd64/jre --enable-java-home --with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-5-amd64 --with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-5-amd64 --with-arch-directory=amd64 --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --enable-objc-gc --enable-multiarch --disable-werror --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib --with-tune=generic --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.11) 
COLLECT_GCC_OPTIONS='-E' '-v' '-mtune=generic' '-march=x86-64'
 /usr/lib/gcc/x86_64-linux-gnu/5/cc1 -E -quiet -v -imultiarch x86_64-linux-gnu - -mtune=generic -march=x86-64 -fstack-protector-strong -Wformat -Wformat-security
ignoring nonexistent directory "/usr/local/include/x86_64-linux-gnu"
ignoring nonexistent directory "/usr/lib/gcc/x86_64-linux-gnu/5/../../../../x86_64-linux-gnu/include"
#include "..." search starts here:
#include <...> search starts here:
 /usr/lib/gcc/x86_64-linux-gnu/5/include
 /usr/local/include
 /usr/lib/gcc/x86_64-linux-gnu/5/include-fixed
 /usr/include/x86_64-linux-gnu
 /usr/include
End of search list.
COMPILER_PATH=/usr/lib/gcc/x86_64-linux-gnu/5/:/usr/lib/gcc/x86_64-linux-gnu/5/:/usr/lib/gcc/x86_64-linux-gnu/:/usr/lib/gcc/x86_64-linux-gnu/5/:/usr/lib/gcc/x86_64-linux-gnu/
LIBRARY_PATH=/usr/lib/gcc/x86_64-linux-gnu/5/:/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/:/usr/lib/gcc/x86_64-linux-gnu/5/../../../../lib/:/lib/x86_64-linux-gnu/:/lib/../lib/:/usr/lib/x86_64-linux-gnu/:/usr/lib/../lib/:/usr/lib/gcc/x86_64-linux-gnu/5/../../../:/lib/:/usr/lib/
COLLECT_GCC_OPTIONS='-E' '-v' '-mtune=generic' '-march=x86-64'
(   0.029s) [main thread  ]        project.cc:166   | Using system include directory flags
  -isystem/usr/lib/gcc/x86_64-linux-gnu/5/include
  -isystem/usr/local/include
  -isystem/usr/lib/gcc/x86_64-linux-gnu/5/include-fixed
  -isystem/usr/include/x86_64-linux-gnu
  -isystem/usr/include
(   0.029s) [main thread  ]        project.cc:170   | To disable this set the discoverSystemIncludes config option to false.
(   0.029s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/reproc/src/c/posix/fork.c
(   0.029s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/reproc/src/c/posix/pipe.c
(   0.029s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/reproc/src/c/posix/reproc.c
(   0.029s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/reproc/src/c/posix/process.c
(   0.029s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/reproc/src/cpp/reproc.cpp
(   0.029s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/reproc/src/cpp/error.cpp
(   0.029s) [main thread  ]        project.cc:69    | Failed to normalize /mnt/prog/cquery/third_party/reproc/src/cpp/parser.cpp
(   0.030s) [main thread  ]          timer.cc:41    | compile_commands.json clang time took 2.2080ms
(   0.030s) [main thread  ]          timer.cc:41    | compile_commands.json our time took 25.25350ms
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/third_party/msgpack-c/include/
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/third_party/reproc/src/c/posix/
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/third_party/rapidjson/include/
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/third_party/doctest/
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/third_party/loguru/
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/third_party/
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/src/
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/third_party/sparsepp/
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/third_party/reproc/include/c/
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/third_party/reproc/include/cpp/
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/third_party/pugixml/src/
(   0.030s) [main thread  ]        project.cc:754   | angle_include_dir: /mnt/prog/cquery/build/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-14.04/include/
(   0.030s) [main thread  ]   command_line.cc:461   | Using arguments /usr/bin/c++ -working-directory=/mnt/prog/cquery/build -DDEFAULT_RESOURCE_DIRECTORY="/mnt/prog/cquery/build/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-14.04/lib/clang/7.0.0" -DLOGURU_FILENAME_WIDTH=18 -DLOGURU_STACKTRACES=1 -DLOGURU_THREADNAME_WIDTH=13 -DLOGURU_WITH_STREAMS=1 -I/mnt/prog/cquery/src -I/mnt/prog/cquery/third_party -I/mnt/prog/cquery/third_party/doctest -I/mnt/prog/cquery/third_party/loguru -I/mnt/prog/cquery/third_party/msgpack-c/include -I/mnt/prog/cquery/third_party/pugixml/src -I/mnt/prog/cquery/third_party/rapidjson/include -I/mnt/prog/cquery/third_party/sparsepp -I/mnt/prog/cquery/third_party/reproc/include/c -I/mnt/prog/cquery/third_party/reproc/include/cpp -isystem /mnt/prog/cquery/build/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-14.04/include -O3 -DNDEBUG -Wall -Wno-sign-compare -Wno-unknown-pragmas -Wno-return-type -Wno-unused-result -pthread -std=c++14 /media/ubuntu-gnome/Arch/prog/cquery/src/command_line.cc -Wno-unknown-warning-option -fparse-all-comments -isystem/usr/include/c++/5 -isystem/usr/include/x86_64-linux-gnu/c++/5 -isystem/usr/include/c++/5/backward -isystem/usr/lib/gcc/x86_64-linux-gnu/5/include -isystem/usr/local/include -isystem/usr/lib/gcc/x86_64-linux-gnu/5/include-fixed -isystem/usr/include/x86_64-linux-gnu -isystem/usr/include
(   0.070s) [      526F700]  clang_indexer.cc:2366  | /media/ubuntu-gnome/Arch/prog/cquery/src/cache_manager.h:3:10 'optional.h' file not found
(   0.070s) [      526F700]  clang_indexer.cc:2366  | /media/ubuntu-gnome/Arch/prog/cquery/src/cache_manager.h:3:10 'optional.h' file not found
(   0.070s) [main thread  ]  clang_indexer.cc:2402  | Got 2 diagnostics
(   0.071s) [main thread  ]        loguru.hpp:1767  | atexit



https://www.youtube.com/watch?v=swciKGcwyE0 10 VIM Better Buffer Switcher 2017
_________________________________________________________________________________________________________
