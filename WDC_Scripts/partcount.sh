#!/bin/bash
EMAIL="HM230067@Teradata.com SHIGEYUKI.NAKAGAWA@wdc.com"
TS=`date +"%Y%m%d_%H%M"`
NOW=$(date +"%Y_%m_%d")
FILENAME="/home/svc-awor-bdppmon/log/part_count_$TS".csv

ssh svc-awor-bdppmon@abo-lp-mstr03.wdc.com mysql -u root -p****** -D metastore -e "'select TBLS.TBL_ID as TABLE_ID,DBS.NAME as DB_NAME,TBLS.TBL_NAME as TABLE_NAME,count(PART_ID) AS TBL_PARTNS_COUNT from TBLS , PARTITIONS, DBS where TBLS.TBL_ID = PARTITIONS.TBL_ID AND DBS.DB_ID = TBLS.DB_ID group by TBLS.TBL_ID order by TBL_PARTNS_COUNT DESC;'"  | tr "\t" "|" > $FILENAME 

mailx -r "svc-awor-bdppmon@wdc.com (Partition Count Report)" -S smtp="10.86.1.25:25" -s "BDP3.0:Partition Count on $NOW " -a $FILENAME  $EMAIL < $FILENAME