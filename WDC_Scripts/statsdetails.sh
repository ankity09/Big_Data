#!/bin/bash
EMAIL="HM230067@Teradata.com"
NOW=$(date +"%Y_%m_%d")
FILE_PATH=/home/svc-awor-bdppmon/scripts/logs
FILE=/home/svc-awor-bdppmon/scripts/logs/stats_details.csv


ssh svc-awor-bdppmon@abo-lp-mstr03.wdc.com mysql -u root -p***** -D metastore -e "'select distinct DB_NAME,TABLE_NAME,TIMESTAMPDIFF(DAY,(SELECT FROM_UNIXTIME(LAST_ANALYZED)),(SELECT current_timestamp)) as DAYS_TABLES_LAST_ANALYZED from TAB_COL_STATS ORDER BY 3 desc;'" | tr "\t" "|" > $FILE


mailx  -r "monitor@wdc.com (HADOOP ALERTS STATSDETAILS)" -S smtp="10.86.1.25:25" -s "DETAILS WHEN TABLES ANALYZED (DAYS) on $NOW " -a $FILE $EMAIL < $FILE