#!/bin/bash

chmod +x Mergerfs.sh


a='wget https://downloads.plex.tv/plex-media-server/1.13.5.5332-21ab172de/plexmediaserver_1.13.5.5332-21ab172de_amd64.deb'
b='sudo dpkg -i plexmediaserver_1.13.5.5332-21ab172de_amd64.deb' 
c='rm plexmediaserver*.deb'

echo "Installer  Plex?"

select answer in "Yes" "No"; do
    case $answer in
        Yes ) echo "Installer Plex" && $a 1>/dev/null 2>&1;$b 1>/dev/null 2>&1;$c 1>/dev/null 2>&1; sudo ./Mergerfs.sh;;
         No ) echo "NO" & sudo ./Mergerfs.sh;;
          * ) echo "Please answer yes or no.";;
    esac
done








