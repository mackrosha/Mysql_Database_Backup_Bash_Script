# Mysql_Database_Backup_Bash_Script

first create a .sh script to root or where you want
sudo nano/root/mysql_backup_to_ftp.sh

den copy and paste my script

den run ./mysql_backup_to_ftp.sh

and please check you FTP Folder, you will find you database backup

and add this script to you server crontab


chmod +x mysql_backup_to_ftp.sh


crontab -e

0 2 * * * /root/mysql_backup_to_ftp.sh >> /var/log/mysql_backup.log 2>&1

and save crontab 

note you need to make sure that you have lftp install in you ubuntu server

sudo apt update
sudo apt install lftp -y

