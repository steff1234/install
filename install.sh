#!/bin/bash


## Skal Installeres Som Root

# Ask the user for login details

read -p 'Username: ' uservar
echo
echo Nu vi klar $uservar

# Set User Groups Og Rclone Info
USER=$uservar
GROUP=$uservar


## Backup op gamle RCLONE Config filer!
FILE=/home/$USER/.config/rclone/rclone.conf
FILE1=/etc/systemd/system/rclonemount.service
FILE2=/etc/systemd/system/mergerfs.service
FILE3=/home/$USER/scripts/rclone-upload.sh

if [ -f $FILE ]; then
    cp $FILE $FILE.bak
    echo "file successfully backed up"
else
    echo "file does not exists" 1>/dev/null 2>&1
    
fi
if [ -f $FILE1 ]; then
    cp $FILE1 $FILE1.bak
    echo "file successfully backed up"
else
    echo "file does not exists" 1>/dev/null 2>&1
    
fi
if [ -f $FILE2 ]; then
    cp $FILE2 $FILE2.bak
    echo "file successfully backed up"
else
    echo "file does not exists" 1>/dev/null 2>&1
    
fi
if [ -f $FILE3 ]; then
    cp $FILE3 $FILE3.bak
    echo "file successfully backed up"
else
    echo "file does not exists" 1>/dev/null 2>&1
    
fi

# Fjern Gamle services

rm /etc/systemd/system/rclonemount.service 1>/dev/null 2>&1
rm /etc/systemd/system/mergerfs.service 1>/dev/null 2>&1

## Create directories for my mounts
mkdir /home/$USER/mergerfs
sudo -u $USER mkdir -p /home/$USER/{mnt/{move,gdrive,media},.config/rclone,scripts/logs}
touch /etc/systemd/system/{rclonemount.service,mergerfs.service}
sudo -u $USER touch /home/$USER/scripts/{rclone-upload.sh,slet.sh}
sudo -u $USER touch /home/$USER/.config/rclone/rclone.conf
sudo -u $USER chown $USER:$GROUP /home/$USER/{mnt/{move,gdrive,media},.config/rclone,scripts/logs}
sudo -u $USER chown $USER:$GROUP /home/$USER/.config/rclone/rclone.conf
sudo -u $USER chmod a+x /home/$USER/scripts/{rclone-upload.sh,slet.sh}

## Installer unzip og fuse MATE Qbittorrent NoMachine plex 
 
read -p "   ** Installer Programmer ** | Tryk Enter For Og Komme Videre!"

## Update Upgrade
echo "***Update og Upgrade" 
sudo apt update -y && sudo apt upgrade -y
clear
## Mate
echo Vil du installer Mate desktop? "(Y or N)"

read x
# now check if $x is "y"
if [ "$x" = "y" ]; then
echo "Installer Mate desktop tager lidt tid"
sudo apt-add-repository ppa:ubuntu-mate-dev/xenial-mate -y 1>/dev/null 2>&1
sudo apt -y update && sudo apt -y install mate 1>/dev/null 2>&1
sudo apt -y dist-upgrade  1>/dev/null 2>&1  
fi
clear
## NoMachine
echo Vil du installer NoMachine? "(Y or N)"

read q
# now check if $q is "y"
if [ "$q" = "y" ]; then
echo "Installer NoMachine"
cd /home/$USER/mergerfs 1>/dev/null 2>&1
which nomachine >/dev/null 2>&1 || wget https://download.nomachine.com/download/6.2/Linux/nomachine_6.2.4_1_amd64.deb 1>/dev/null 2>&1
sudo dpkg -i nomachine_6.2.4_1_amd64.deb 1>/dev/null 2>&1
rm nomachine*.deb
cd 1>/dev/null 2>&1
fi
clear
## Curl

echo "*** Checking curl"
which curl >/dev/null 2>&1 || apt -y install curl 1>/dev/null 2>&1

## Unzip
echo "*** Checking unzip"
witch unzip >/dev/null 2>&1 || apt -y install unzip 1>/dev/null 2>&1

## Rclone
echo "*** Checking Rclone"
which rclone >/dev/null 2>&1 || curl https://rclone.org/install.sh | sudo bash 1>/dev/null 2>&1

## Fuse
echo "*** Checking fuse support"
which fuse >/dev/null 2>&1 || apt -y install fuse 1>/dev/null 2>&1

## Filebot
echo Vil du installer FileBot? "(Y or N)"

read w
# now check if $w is "y"
if [ "$w" = "y" ]; then
echo "Installer FileBot"
cd /home/$USER/mergerfs 1>/dev/null 2>&1
which filebot >/dev/null 2>&1 || wget https://get.filebot.net/filebot/FileBot_4.8.2/FileBot_4.8.2_amd64.deb 1>/dev/null 2>&1
dpkg -i FileBot_4.8.2_amd64.deb 1>/dev/null 2>&1
echo "****** Tryk Enter *******"
## MediaInfo
sudo apt -y install mediainfo 1>/dev/null 2>&1
fi
clear
## Qbittorrent 
echo Vil du installer Qbittorrent? "(Y or N)"

read e
# now check if $e is "y"
if [ "$e" = "y" ]; then
echo "Installer Qbittorrent"
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y 1>/dev/null 2>&1
sudo apt-get update && sudo apt-get -y install qbittorrent 1>/dev/null 2>&1
fi
clear
## Plex

echo Vil du installer Plex? "(Y or N)"

read r
# now check if $r is "y"
if [ "$r" = "y" ]; then
echo "Installer Plex"
wget https://downloads.plex.tv/plex-media-server/1.13.5.5332-21ab172de/plexmediaserver_1.13.5.5332-21ab172de_amd64.deb 1>/dev/null 2>&1
dpkg -i plexmediaserver_1.13.5.5332-21ab172de_amd64.deb 1>/dev/null 2>&1
fi
clear
## installer chromium-browser
sudo apt -y install chromium-browser 1>/dev/null 2>&1

## Installer Megerfs
echo "*** Installer MergerFs"
cd /home/$USER/mergerfs 1>/dev/null 2>&1
wget https://github.com/trapexit/mergerfs/releases/download/2.24.2/mergerfs_2.24.2.ubuntu-xenial_amd64.deb 1>/dev/null 2>&1
dpkg -i mergerfs_2.24.2.ubuntu-xenial_amd64.deb 1>/dev/null 2>&1
rm mergerfs*.deb 1>/dev/null 2>&1
cd 1>/dev/null 2>&1
rm -rf /home/$USER/mergerfs 1>/dev/null 2>&1

## Update fuse.conf Med allow other

echo "user_allow_other" >> /etc/fuse.conf

clear 
#################################################################################################

# Rclone Gdrive Config 
echo "**********  Rclone Config Setup!"
echo "**********  Indtast Google Drive Client_id"
read -p 'Client_id: ' clientid
echo "**********  Indtast Google Drive Client_secret"
read -p 'client_secret: ' clientsecret
sudo -s rclone authorize drive
echo "*********   Indset Her!"
read -p 'Paste the following into your remote machine; ' token

#################################################################################################

## Rclone.config

cat >> /home/$USER/.config/rclone/rclone.conf <<EOF

[gdrive]
type = drive
client_id = $clientid
client_secret = $clientsecret
scope = 
root_folder_id = 
service_account_file = 
token = $token

[gcrypt]
type = crypt
remote = gdrive:/encrypt
filename_encryption = standard
directory_name_encryption = true



EOF

## Rclone Crypt Password
echo "Rclone Crypt Password!"
echo "*********    Indtast Rclone crypt Password 1"
read -s -p "Password_1: " pass1
echo "*********    Indtast Rclone crypt Password_2"
read -s -p "Indtast Password 2: " pass2


sudo -s rclone config password gcrypt password $pass1
sudo -s rclone config password gcrypt password2 $pass2

## Lave Rclone Mount

#######################################################################################


cat >> /etc/systemd/system/rclonemount.service <<EOF
[Unit]
Description=RClone Service
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/rclone mount gcrypt: /home/$USER/mnt/gdrive \
--allow-other \
--dir-cache-time 72h \
--vfs-read-chunk-size 10M \
--vfs-read-chunk-size-limit 512M \
--buffer-size 1G \
--umask 002 \
--log-level INFO \
--log-file /home/$USER/scripts/logs/rclone-mount.txt
ExecStop=/bin/fusermount -uz /home/$USER/mnt/gdrive
Restart=on-abort
User=$USER
Group=$USER

[Install]
WantedBy=default.target 
EOF

## Megerfs Mount

cat >> /etc/systemd/system/mergerfs.service <<EOF
[Unit]
Description=Megerfs Service
After=rclonemount.service
RequiresMountsFor=/home/$USER/mnt/gdrive

[Service]
Type=forking
User=$USER
Group=$USER
ExecStart=/usr/bin/mergerfs -o defaults,sync_read,allow_other,category.action=all,category.create=ff /home/$USER/mnt/move:/home/$USER/mnt/gdrive /home/$USER/mnt/media
ExecStop=/home/$USER/mnt/gdrive
Restart=on-abort
RestartSec=5
StartLimitInterval=60s
StartLimitBurst=3

[Install]
WantedBy=rclonemount.service

EOF

## Set UserName Rclone Upload

echo -e "#!/bin/bash\nLOGFILE=/home/$USER/scripts/logs/rclone-upload.log\nFROM=/home/$USER/mnt/move\nTO=gcrypt:/" >> /home/$USER/scripts/rclone-upload.sh 

## Rclone Upload Scripts

cat >> /home/$USER/scripts/rclone-upload.sh << 'EOF'

if pidof -o %PPID -x "$0"; then
   exit 1
fi

# CHECK FOR FILES IN FROM FOLDER THAT ARE OLDER THAN 15 MINUTES
if find $FROM* -type f -mmin +15 | read
  then
  start=$(date +'%s')
  echo "$(date "+%d.%m.%Y %T") RCLONE UPLOAD STARTED" | tee -a $LOGFILE
  # MOVE FILES OLDER THAN 15 MINUTES 
  rclone move "$FROM" "$TO" --transfers=20 --bwlimit 25M --checkers=20 --delete-after --min-age 15m --log-file=$LOGFILE
  echo "$(date "+%d.%m.%Y %T") RCLONE UPLOAD FINISHED IN $(($(date +'%s') - $start)) SECONDS" | tee -a $LOGFILE
fi
exit

EOF

########################################################################

##Slet Tomme Mapper 


cat >> /home/$USER/scripts/slet.sh <<EOF

#!/bin/bash


# remove empty directories
find /home/$USER/mnt/move/movies* -empty -type d -delete 2>/dev/null
find /home/$USER/mnt/move/tv* -empty -type d -delete 2>/dev/null
find /home/$USER/mnt/move/Unsorted* -empty -type d -delete 2>/dev/null
find /home/$USER/mnt/move/Movies 4K* -empty -type d -delete 2>/dev/null
find /home/$USER/mnt/move/Tv 4K* -empty -type d -delete 2>/dev/null
find /home/$USER/mnt/move/.Trash-1000/* -empty -type d -delete 2>/dev/null

EOF

#######################################################################

## Set Crontab

cat >> /etc/crontab << EOF
* * * * * $USER /home/$USER/scripts/rclone-upload.sh
* * * * * $USER /home/$USER/scripts/slet.sh
EOF

#######################################################################
## Filebot Command til Qbittorrent
cat >> /home/$USER/scripts/FileBot-Commad <<EOF

filebot -script fn:amc --output "/home/DIT-USER-NAME/mnt/media" --action copy --conflict auto -non-strict --log-file "/home/DIT-USER-NAME/scripts/logs/filebot-amc.log" --def unsorted=y music=y artwork=n plex="localhost:NPLEXTOKEN" "ut_dir=%F" "ut_kind=multi" "ut_title=%N" "ut_label=%L" --def movieFormat="{vf == /2160p/ ? 'Movies 4K' : vf =~ /1080p|720p/ ? 'movies' : 'movies'}/{'da' in Audio.Language ? 'Dansk' : 'Engelsk'}/{n}/{n.space('.')}.{y}{'.'+source}.{vc}{'.'+lang}" seriesFormat="{n.replaceTrailingBrackets()}{vf == /2160p/ ? 'Tv 4K' : vf =~ /1080p|720p/ ? 'tv' : 'tv'}/{'da' in Audio.Language ? 'Dansk' : 'Engelsk'}/{n}/{'Season '+s}/{n} - {s00e00} - {t}{'.'+lang}"

EOF
## start rclone Mount

systemctl daemon-reload
systemctl enable rclonemount.service
systemctl start rclonemount.service

## Start megerfs Mount
rm install.sh
systemctl enable mergerfs.service
systemctl start mergerfs.service
## Reboot
echo "så tager vi lige en Genstart"
echo "Efter Genstart | Log Ind Med NoMachine"
read -p "Tryk Enter For Og Genstarte"
sudo -s reboot
