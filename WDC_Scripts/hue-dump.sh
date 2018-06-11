set -vx
DATE=`date +"%Y-%m-%d"`
#$Work_Dir=/home/bjain/scripts/bkp-scripts/hue
MAIL=HM230067@Teradata.com
DB_PATH=/home/svc-awor-bdppmon/scripts/db_backup/hue/data-files
DST_PATH=/var/www/html/HGST/DB_Backup/hue
#ssh svc-awor-bdppmon@abo-lp-mstr03.wdc.com 'bash -s' < /home/svc-awor-bdppmon/scripts/db_backup/hue/hue-dump-comm.sh 1> /home/svc-awor-bdppmon/scripts/db_backup/hue/data-files/hue-metadata-bkp-$DATE.sql 2>/home/svc-awor-bdppmon/scripts/db_backup/hue/error/hue-metabkp-error-$DATE.txt

mysqldump -habo-lp-mstr04.wdc.com -urepl -p***** hue > /home/svc-awor-bdppmon/scripts/db_backup/hue/data-files/hue-metadata-bkp-$DATE.sql


LATEST_DB_FILE=`ls -rt /home/svc-awor-bdppmon/scripts/db_backup/hue/data-files/ | tail -1`
cp $DB_PATH/$LATEST_DB_FILE $DST_PATH/
rm -f `ls -t /var/www/html/HGST/DB_Backup/hue/hue-metadata-bkp*.sql |awk 'NR>5'`
rm -f `ls -t /home/svc-awor-bdppmon/scripts/db_backup/hue/data-files/hue-metadata-bkp*.sql |awk 'NR>5'`
echo "Hue DB backup completed and saved on http://10.240.4.16/hgst/DB_Backup/hue/" | mailx -s "HUE DB backup completed" -S smtp="10.86.1.25:25" -r monitor@hgst.com $MAIL