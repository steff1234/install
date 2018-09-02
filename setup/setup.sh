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
filebot -script fn:amc --output "/home/$USER/mnt/media" --action copy --conflict auto -non-strict --log-file "/home/$USER/scripts/logs/filebot-amc.log" --def unsorted=y music=y artwork=n plex="localhost:NPLEXTOKEN" "ut_dir=%F" "ut_kind=multi" "ut_title=%N" "ut_label=%L" --def movieFormat="{vf == /2160p/ ? 'Movies 4K' : vf =~ /1080p|720p/ ? 'movies' : 'movies'}/{'da' in Audio.Language ? 'Dansk' : 'Engelsk'}/{n}/{n.space('.')}.{y}{'.'+source}.{vc}{'.'+lang}" seriesFormat="{vf == /2160p/ ? 'Tv 4K' : vf =~ /1080p|720p/ ? 'tv' : 'tv'}/{'da' in Audio.Language ? 'Dansk' : 'Engelsk'}/{n}/{'Season '+s}/{n} - {s00e00} - {t}{'.'+lang}"
EOF
sudo rm -rf /home/$USER/mergerfs
sudo rm -rf /home/$USER/install
## start rclone Mount
systemctl daemon-reload
systemctl enable rclonemount.service
systemctl start rclonemount.service

## Start megerfs Mount

systemctl enable mergerfs.service
systemctl start mergerfs.service
## Reboot
echo "så tager vi lige en Genstart"
echo "Efter Genstart | Log Ind Med NoMachine"
read -p "Tryk Enter For Og Genstarte"
sudo -s reboot
