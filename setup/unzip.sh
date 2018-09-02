#!/bin/bash

chmod +x rclone.sh

echo "Installer Unzip?"

select answer in "Yes"; do
    case $answer in
        Yes ) echo "Installer Unzip" && sudo apt -y install unzip 1>/dev/null 2>&1; ./rclone.sh;;
          * ) echo "Please answer yes.";;
    esac
done
