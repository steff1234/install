#!/bin/bash

chmod +x Filebot.sh

a='wget https://download.nomachine.com/download/6.2/Linux/nomachine_6.2.4_1_amd64.deb'
b='sudo dpkg -i nomachine_6.2.4_1_amd64.deb'
c='rm nomachine*.deb'


echo "Installer NoMachine?"

select answer in "Yes" "No"; do
    case $answer in
        Yes ) echo "Installer NoMachine" && $a 1>/dev/null 2>&1;$b;$c 1>/dev/null 2>&1; sudo ./Filebot.sh;;
         No ) echo "NO" & sudo ./Filebot.sh;;
          * ) echo "Please answer yes or no.";;
    esac
done
clear

