#! /bin/bash

cd /opt/
wget --no-check-certificate https://github.com/rackmount-everything/global-comfort-zone/archive/master.tar.gz
gtar -xzf ./master.tar.gz
mv ./global-comfort-zone-master/* ./
rm master.tar.gz README.md LICENSE
rm -r images/ global-comfort-zone-master/


############## WARNING INPUT
echo "This script is about to overwrite the dotfiles in your home directory ($HOME)."
read -p  "Are you sure you would like to continue [Y/n]? "

case $REPLY in
"y"|"Y"|"yes"|"Yes"|"YES")

        cd /opt/custom/root
        touch .vimrc
        touch .viminfo

        if [ -d /root/.vim ]; then
                mv /root/.vim /opt/custom/root/.vim
        else
                mkdir /opt/custom/root/.vim
        fi 

        if [ -d /root/.ssh ]; then
                mv /root/.ssh /opt/custom/root/.ssh
        else
                mkdir /opt/custom/root/.ssh
        fi 

        ln -nsf /opt/custom/root/.[a-zA-Z0-9]* /root/
        ;;

*) exit 1


esac
