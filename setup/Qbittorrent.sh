#!/bin/bash

chmod +x ./Plex.sh

a='sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y'
b='sudo apt-get update 1>/dev/null 2>&1' 
c='sudo apt-get -y install qbittorrent'


echo "Installer  Qbittorrent?"

select answer in "Yes" "No"; do
    case $answer in
        Yes ) echo "Installer Qbittorrent" && $a 1>/dev/null 2>&1;$b1>/dev/null 2>&1;$c 1>/dev/null 2>&1; sudo ./Plex.sh;;
         No ) echo "NO" & sudo ./Plex.sh;;
          * ) echo "Please answer yes or no.";;
    esac
done







