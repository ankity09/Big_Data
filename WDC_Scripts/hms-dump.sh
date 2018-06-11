# BDP 3.0
set -vx
DATE=`date +"%Y-%m-%d"`
EMAIL="HM230067@Teradata.com"
DB_PATH=/home/svc-awor-bdppmon/scripts/db_backup/hms/data-file
DST_PATH=/var/www/html/HGST/DB_Backup/hms

ssh svc-awor-bdppmon@abo-lp-mstr04.wdc.com 'bash -s' < /home/svc-awor-bdppmon/scripts/db_backup/hms/hms-dump-comm.sh 1>/home/svc-awor-bdppmon/scripts/db_backup/hms/data-file/hms-metadata-bkp-$DATE.sql 2>/home/svc-awor-bdppmon/scripts/db_backup/hms/error/hms-metabkp-error-$DATE.txt

LATEST_DB_FILE=`ls -rt /home/svc-awor-bdppmon/scripts/db_backup/hms/data-file/ | tail -1`
cp $DB_PATH/$LATEST_DB_FILE $DST_PATH/
rm -f `ls -t /home/svc-awor-bdppmon/scripts/db_backup/hms/data-file/hms-metadata-bkp*.sql |awk 'NR>5'`
rm -f `ls -t /var/www/html/HGST/DB_Backup/hms/hms-metadata-bkp*.sql|awk 'NR>5'`
echo "Hms DB backup completed and saved on http://10.240.4.16/hgst/DB_Backup/hms/" | mailx -s "HMS metastore DB backup completed" -S smtp="10.86.1.25:25" -r monitor@hgst.com $EMAIL