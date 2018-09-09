#!/bin/bash

chmod +x curl.sh

a='sudo apt-add-repository ppa:ubuntu-mate-dev/xenial-mate -y'
b='sudo apt -y update' 
d='sudo apt -y dist-upgrade'
c='sudo apt -y install mate'
e='sudo apt -y install chromium-browser'
f='sudo add-apt-repository ppa:notepadqq-team/notepadqq -y'
g='sudo apt-get -y update'
h='sudo apt-get -y install notepadqq'

echo "Installer  Mate desktop?"

select answer in "Yes" "No"; do
    case $answer in
        Yes ) echo "Installer Mate" && $a;$b;$c;$d;$e;$f;$g;$h; sudo ./curl.sh;;
         No ) echo "NO" & sudo ./curl.sh;;
          * ) echo "Please answer Yes or No.";;
    esac
done








