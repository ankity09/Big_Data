#!/bin/bash
DATE=`date +%m-%d-%Y-%H_%M_%S`
SERVER=abo-lp-cm01.hgstbdp.local
MAIL=HM230067@Teradata.com
SCM_PATH=/var/www/html/HGST/report/CM_DB/scm_$DATE.sql
AMON_PATH=/var/www/html/HGST/report/CM_DB/amon_$DATE.sql
RMON_PATH=/var/www/html/HGST/report/CM_DB/rmon_$DATE.sql
SCM_DUMP=`ssh $SERVER mysqldump -hlocalhost -uroot -p***** scm > $SCM_PATH`
AMON_DUMP=`ssh $SERVER mysqldump -hlocalhost -uroot -p***** amon > $AMON_PATH`
RMON_DUMP=`ssh $SERVER mysqldump -hlocalhost -uroot -p***** rmon > $RMON_PATH`

if 
	[ -s "$SCM_PATH" ]
then
	echo "CM: SCM database backup completed and saved on http://10.240.4.16/HGST/report/CM_DB/." | mailx -s "SCM  database backup completed" -r monitor@hgst.com -S smtp="10.86.1.25:25" $MAIL 
 

if 
	[ -s "$AMON_PATH" ]
then
	echo "CM: AMON database backup completed and saved on http://10.240.4.16/HGST/report/CM_DB/." |  mailx -s "AMON  database backup completed" -r monitor@hgst.com -S smtp="10.86.1.25:25" $MAIL

if 
	[ -s $RMON_PATH ]
then
	echo "CM: RMON database backup completed and saved on http://10.240.4.16/HGST/report/CM_DB/." |  mailx -s "RMON  database backup completed" -r monitor@hgst.com -S smtp="10.86.1.25:25" $MAIL

else 

 echo	"Backup of one of the CM databse not completed successfuly." | mailx -s "CM database backup not completed" -r monitor@hgst.com -S smtp="10.86.1.25:25" $MAIL

fi
fi
fi
rm -f `ls -t /var/www/html/HGST/report/CM_DB/scm_* |awk 'NR>5'`
rm -f `ls -t /var/www/html/HGST/report/CM_DB/amon_* |awk 'NR>5'`
rm -f `ls -t /var/www/html/HGST/report/CM_DB/rmon_* |awk 'NR>5'