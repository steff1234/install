#!/bin/bash

chmod +x ./setup.sh

a='wget https://github.com/trapexit/mergerfs/releases/download/2.24.2/mergerfs_2.24.2.ubuntu-xenial_amd64.deb'
b='sudo dpkg -i mergerfs_2.24.2.ubuntu-xenial_amd64.deb' 
c='rm mergerfs*.deb'


echo "Installer  Mergerfs?"

select answer in "Yes"; do
    case $answer in
        Yes ) echo "Installer Mergerfs" && $a >/dev/null 2>&1;$b;$c >/dev/null 2>&1; sudo ./setup.sh;;
          * ) echo "Please answer yes.";;
    esac
done



