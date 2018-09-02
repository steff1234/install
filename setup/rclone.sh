#!/bin/bash

chmod +x NoMachine.sh


echo "Installer Rclone?"

select answer in "Yes" "No"; do
    case $answer in
        Yes ) echo "Installer Rclone" && curl https://rclone.org/install.sh | sudo bash 1>/dev/null 2>&1; sudo ./NoMachine.sh;;
         No ) echo "NO" & sudo ./NoMachine.sh;;
          * ) echo "Please answer yes or no.";;
    esac
done




