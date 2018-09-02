#!/bin/bash
chmod +x unzip.sh


echo "Installer  Curl?"




select answer in "Yes"; do
    case $answer in
        Yes ) echo "Installer Curl" && sudo apt -y install curl 1>/dev/null 2>&1; ./unzip.sh;;
           * ) echo "Please answer yes.";;
    esac
done

