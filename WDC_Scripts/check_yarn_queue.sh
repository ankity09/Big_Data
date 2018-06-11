##Abhay Patil## ##April 2016## 
##Updated 23/03/2017
#	Added check for root.hgst
#	Added check for root.default

SERVER=abo-lp-mstr04.wdc.com
FPATH=/home/svc-awor-bdppmon/scripts/logs/yarn_queue_status.txt
#RCPT=HM230067@Teradata.com
RCPT=HM230067@Teradata.com,abhay.patil@wdc.com
APPLIST=/home/svc-awor-bdppmon/scripts/logs/applist.txt
JOBLIST=/home/svc-awor-bdppmon/scripts/logs/joblist.txt
PENDING=/home/svc-awor-bdppmon/scripts/logs/pending.txt
date > $FPATH
ssh svc-awor-bdppmon@abo-lp-mstr04.wdc.com  yarn queue -status root >> $FPATH
echo "               " >> $FPATH
echo "               " >> $FPATH
CUR_CAPACITY=`tail $FPATH | grep "Current Capacity" | cut -d ":" -f2 | cut -d "%" -f1 | cut -d "." -f1`
#check root.hgst and root.default
ssh svc-awor-bdppmon@abo-lp-mstr04.wdc.com  yarn queue -status root.hgst >> $FPATH
ssh svc-awor-bdppmon@abo-lp-mstr04.wdc.com  yarn queue -status root.default >> $FPATH

#list running application
ssh svc-awor-bdppmon@abo-lp-mstr04.wdc.com yarn application -list > $APPLIST
ssh svc-awor-bdppmon@abo-lp-mstr04.wdc.com mapred job -list > $JOBLIST
echo "               " >> $FPATH
echo "               " >> $FPATH
ssh svc-awor-bdppmon@abo-lp-mstr04.wdc.com mapred job -list | grep PREP > $PENDING
echo "               " >> $FPATH

if [ $CUR_CAPACITY -gt 90 ] ; then 
	cat $FPATH > /home/svc-awor-bdppmon/scripts/logs/yarn_jobs.txt 1>/home/svc-awor-bdppmon/scripts/logs/tmpfile
	echo "Capacity increased"
	PENDING_JOBS=`cat $PENDING | wc -l`
        mailx -S smtp="10.86.1.25:25" -s "Yarn:ROOT queue current capacity is greater than 90%|Pending Jobs:$PENDING_JOBS " -a $APPLIST -a $JOBLIST $RCPT < /home/svc-awor-bdppmon/scripts/logs/tmpfile
fi