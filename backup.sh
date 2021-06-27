#!/bin/bash

#zona de variabile
user="username"
host="client ip"

backup_computer="server username"
remote="server ip"

ok_backup=0 

backupdate=$(date +%b-%d-%y)
backuptime=$(date +%H:%M)

destination_backup="/home/$backup_computer/backups/"

backupfile="/home/$user/$user.tar.gz"
sizeofBackup=$(du $backupfile | awk '{print$1}')

echo "$backuptime ~ $backupdate -- Sync/home/$user.." 


tar -cpzf $backupfile /home/$user 2> "logtar.txt"

remote_backup="$user~$backupdate~$backuptime.tar.gz"

ssh -q $backup_computer@$remote df /home | egrep -A1 "Available" | awk '{print$4}' | tail -n 1 > log

if [[ $(($(cat log)-$sizeofBackup)) -le 0 ]];
then 
{
echo "[WARNING!] The backup computer has low memory" >> logfile.txt
echo "[WARNING!] Destination file didn't reach to $backup_computer at $backupdate ~ $backuptime." >> logfile.txt
echo "[ERROR MEMORY!] = LOW DISK SPACE for $backup_computer"
}
else
{

scp $backupfile $backup_computer@$remote:$destination_backup$remote_backup&&echo "Home directory succesfully downloaded to $destination_backup at $backupdate ~ $backuptime.">>logfile.txt&&ok_backup=1

if [[ $ok_backup != "1" ]];
then
echo "[WARNING!] Destination file didn't reach to $backup_computer at $backupdate ~ $backuptime." >> logfile.txt
fi
}
fi
