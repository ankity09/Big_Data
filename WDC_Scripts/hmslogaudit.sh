#!/bin/bash
#
#
#
#
#


DSTPTH=/mnt/log/splunk/HMS
LOGPTH=/var/log/hive
SERVER1=abo-lp-mstr03.wdc.com
SERVER2=abo-lp-mstr04.wdc.com
MD5SERVER1=$(ssh svc-awor-bdppmon@$SERVER1 md5sum $LOGPTH/hadoop-cmf-hive4-HIVEMETASTORE-$SERVER1.log.out.1|awk '{print $1}')
MD5SERVER2=$(ssh svc-awor-bdppmon@$SERVER2 md5sum $LOGPTH/hadoop-cmf-hive4-HIVEMETASTORE-$SERVER2.log.out.1|awk '{print $1}')



if [ $MD5SERVER1 == `cat /tmp/MD5SRV1|awk '{print $1}'` ]
then
	echo "`date`:SRV1 no update"
else
	ssh svc-awor-bdppmon@$SERVER1 cat $LOGPTH/hadoop-cmf-hive4-HIVEMETASTORE-$SERVER1.log.out.1|grep org.apache.hadoop.hive.metastore.HiveMetaStore.audit|awk '{print $1,$2,$6,$8,$9,$10,$11,$13,$14}' |awk '{gsub(/=/,"=\""); $1 = "["$1; gsub(/ ugi/,"] (bdphmsaudit) ugi") gsub(/ cmd=/,"\" cmd=") gsub(/ : db=/,"\" db=") gsub(/ tbl=/,"\" tbl=");print$0"\""}' >$DSTPTH/audit-mstr03.log.`date '+%Y%m%d%H%M'`

#	LASTFILE=`ls -lrth $DSTPTH | tail -1 | awk '{print $9}'`

	echo -e " `date`: $LASTFILE saved to $DSTPTH/"

###Uploading file to splunk
#	sudo /opt/splunkforwarder/bin/splunk add monitor /mnt/log/splunk/HMS/$LASTFILE -index active-archive -sourcetype bdphmsaudit -auth admin:changeme
#echo $MD5SERVER1 > /tmp/MD5SRV1
fi



## Getting log file from master03 server##

if [ $MD5SERVER2 == `cat /tmp/MD5SRV2|awk '{print $1}'` ]
then
	echo "`date`:SRV2 no update"
else
        ssh svc-awor-bdppmon@$SERVER2 cat $LOGPTH/hadoop-cmf-hive4-HIVEMETASTORE-$SERVER2.log.out.1|grep org.apache.hadoop.hive.metastore.HiveMetaStore.audit| awk '{print $1,$2,$6,$8,$9,$10,$11,$13,$14}'|awk '{gsub(/=/,"=\""); $1 = "["$1; gsub(/ ugi/,"] (bdphmsaudit) ugi") gsub(/ cmd=/,"\" cmd=") gsub(/ : db=/,"\" db=") gsub(/ tbl=/,"\" tbl=");print$0"\""}' > $DSTPTH/audit-mstr04.log.`date '+%Y%m%d%H%M'`

#	LASTFILE=`ls -lrth $DSTPTH | tail -1 | awk '{print $9}'`

	echo -e " `date`: $LASTFILE saved to $DSTPTH/"

###Uploading file to splunk
	#sudo /opt/splunkforwarder/bin/splunk add monitor /mnt/log/splunk/HMS/$LASTFILE -index active-archive -sourcetype bdphmsaudit -auth admin:changeme
#echo $MD5SERVER2 > /tmp/MD5SRV2

fi
exit 0