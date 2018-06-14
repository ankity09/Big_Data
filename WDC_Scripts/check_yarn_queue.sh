##Updated 23/03/2017
#	Added check for root.hgst
#	Added check for root.default

SERVER=server_name
FPATH=/home/user/scripts/logs/yarn_queue_status.txt

RCPT=user@email.com
APPLIST=/home/user/scripts/logs/applist.txt
JOBLIST=/home/user/scripts/logs/joblist.txt
PENDING=/home/user/scripts/logs/pending.txt
date > $FPATH
ssh user@server_name  yarn queue -status root >> $FPATH
echo "               " >> $FPATH
echo "               " >> $FPATH
CUR_CAPACITY=`tail $FPATH | grep "Current Capacity" | cut -d ":" -f2 | cut -d "%" -f1 | cut -d "." -f1`
#check root.hgst and root.default
ssh user@server_name  yarn queue -status root.hgst >> $FPATH
ssh user@server_name  yarn queue -status root.default >> $FPATH

#list running application
ssh user@server_name yarn application -list > $APPLIST
ssh user@server_name mapred job -list > $JOBLIST
echo "               " >> $FPATH
echo "               " >> $FPATH
ssh user@server_name mapred job -list | grep PREP > $PENDING
echo "               " >> $FPATH

if [ $CUR_CAPACITY -gt 90 ] ; then 
	cat $FPATH > /home/user/scripts/logs/yarn_jobs.txt 1>/home/user/scripts/logs/tmpfile
	echo "Capacity increased"
	PENDING_JOBS=`cat $PENDING | wc -l`
        mailx -S smtp="10.86.1.25:25" -s "Yarn:ROOT queue current capacity is greater than 90%|Pending Jobs:$PENDING_JOBS " -a $APPLIST -a $JOBLIST $RCPT < /home/user/scripts/logs/tmpfile
fi