set -vx 
DATE=`date +"%Y-%m-%d"`
#WOrk_Dir=/home/bjain/scripts/bkp-scripts
PASSWD=`cat $WOrk_Dir/login_det.dat |grep -w "oozie" |cut -d " " -f3`
EMAIL=HM230067@Teradata.com
#MAIL=abhay.patil@teradata.com,anjal.naik@teradata.com
DB_PATH=/home/svc-awor-bdppmon/scripts/db_backup/oozie/data-file/
DST_PATH=/var/www/html/HGST/DB_Backup/oozie
ssh svc-awor-bdppmon@abo-lp-mstr03.wdc.com 'bash -s' < /home/svc-awor-bdppmon/scripts/db_backup/oozie/oozie-dump-comm.sh 1>/home/svc-awor-bdppmon/scripts/db_backup/oozie/data-file/oozie-metadata-bkp-$DATE.sql 2>/home/svc-awor-bdppmon/scripts/db_backup/oozie/error/oozie-metabkp-error-$DATE.txt
LATEST_DB_FILE=`ls -rt /home/svc-awor-bdppmon/scripts/db_backup/oozie/data-file/ | tail -1`
cp $DB_PATH/$LATEST_DB_FILE $DST_PATH/
rm -f `ls -t /usr/local/nagios/db_backup/oozie/data-file/oozie-metadata-bkp-* |awk 'NR>5'`
rm -f `ls -t /var/www/html/HGST/DB_Backup/oozie/oozie-metadata-bkp-* |awk 'NR>5'`

echo "Oozie DB backup completed successfully and saved on http://10.240.4.16/hgst/DB_Backup/oozie/" | mailx -s "Oozie DB backup completed" -S smtp="10.86.1.25:25" -r monitor@hgst.com $EMAIL