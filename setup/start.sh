#!/bin/bash

chmod +x curl.sh

a='sudo apt-add-repository ppa:ubuntu-mate-dev/xenial-mate -y'
b='sudo apt -y update' 
c='sudo apt -y dist-upgrade'
d='sudo apt -y install mate'
e='sudo apt -y install chromium-browser'




echo "Installer  Mate desktop?"

select answer in "Yes" "No"; do
    case $answer in
        Yes ) echo "Installer Mate" && $a;$b;$c;$d;$e; sudo ./curl.sh;;
         No ) echo "NO" & sudo ./curl.sh;;
          * ) echo "Please answer Yes or No.";;
    esac
done







