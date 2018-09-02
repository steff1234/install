#!/bin/bash

chmod +x Qbittorrent.sh

a='wget https://get.filebot.net/filebot/FileBot_4.8.2/FileBot_4.8.2_amd64.deb'
b='sudo dpkg -i FileBot_4.8.2_amd64.deb'
c='sudo apt -y install mediainfo'
d='rm FileBot_4.8.2_amd64.deb' 

echo "Installer FileBot?"

select answer in "Yes" "No"; do
    case $answer in
        Yes ) echo "Installer FileBot" && $a 1>/dev/null 2>&1;$b 1>/dev/null 2>&1;$c 1>/dev/null 2>&1;$d 1>/dev/null 2>&1; sudo ./Qbittorrent.sh;;
         No ) echo "NO" & sudo ./Qbittorrent.sh;;
          * ) echo "Please answer yes or no.";;
    esac
done

clear



