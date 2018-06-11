#!/bin/bash
# AUTHOR : Shashank Rathore
# Organization: Teradata
# Desctiption: This script is used to report any user query running for more than 2 Hours. This is currently specific to a teradata client
# Version : 01.01.00 : optimized for performance.
# Version : 02.01.00 : script has been modified to report memory usage for non pipeline users.
#

TIME=`date +%s`

## JOB_TIME  value are in seconds i.e. 3600 is one hour.
#
#
JOB_TIME=7200
#JOB_TIME=1800

## MEM_TH is the memory threshold in MB's. 1000=1GB, 10000=10GB, 100000=100GB.
#
MEM_TH=999999
MAPLIMIT=3000
## CONTACT email address you want to send mail to.
#
#

CONTACT=HM230067@Teradata.com,Hang.Cui@Teradata.com
USER=svc-awor-bdppmon
YARN_HOST=abo-lp-mstr04.wdc.com
## non batch user application more than 2 hours.
#
#
#ssh svc-awor-bdppmon@abo-lp-mstr04.wdc.com kinit -kt /home/svc-awor-bdppmon/svc-AWOR-bdppmon.keytab svc-AWOR-bdppmon@HITACHIGST.GLOBALPLIMIT
#ssh svc-awor-bdppmon@abo-lp-mstr04.wdc.com mapred job -list |grep ^job|grep -v "bdppappdup\|bdppapptfw\|bdppappsem\|bdppappaa\|svc-awor-bdppapp"|awk '{print $9,$4,$3,$1, $12}'|sed 's/M//'|sort -nr> joblist

ssh $USER@$YARN_HOST mapred job -list |grep -v "bdppapp"|grep "RUNNING"|awk '{print $9,$4,$3,$1, $12}'|sed 's/M//'|sort -nr> joblist

cat /dev/null > mappers.out
cat joblist|while read line
        do
        id=`echo $line |awk '{print $4}'`
        maps=`ssh -n $USER@$YARN_HOST mapred job -status $id 2>/dev/null |grep "Launched map tasks"|cut -d "=" -f2`
#        echo "$line $maps"|tee -a $LOG_DIR/mappers.out
        echo "$line $maps" >> mappers.out
        done

        TIME=`date +%s`
echo -e "***Jobs Running more than 2 Hours:" >nb_usr.out
#Checking for jobs running against time threshold
        awk '$1, $3='$TIME' - substr($3,0,10) {print}' mappers.out |awk '$3 > '$JOB_TIME' {print "Mem:"$1,"User:"$2,"Time:"$3,"JobID:"$4,"RMLink:"$5,"Maps:",$6}'|tee -a nb_usr.out
echo -e "\n***Jobs Running above 999GB Memory:" >>nb_usr.out
#Checking for jobs running with high memory.
        awk '$1 > '$MEM_TH', $3='$TIME' - substr($3,0,10) {print "Mem:"$1,"User:"$2,"Time:"$3,"JobID:"$4,"RMLink:"$5,"Maps:",$6}' mappers.out|tee -a nb_usr.out
echo -e "\n***Jobs Running too many Mappers:" >>nb_usr.out
#Checking for jobs against mapper threshold. 
        awk '$6 > '$MAPLIMIT', $3='$TIME' - substr($3,0,10) {print "Mem:"$1,"User:"$2,"Time:"$3,"JobID:"$4,"RMLink:"$5,"Maps:",$6}' mappers.out|tee -a nb_usr.out


#if [ -s nb_usr.out ]; then

#if [ -s joblist ]; then
#	TIME=`date +%s`
#	echo -e "Jobs Running more than 2 Hours:" >nb_usr_2hr.out
#	awk '$1, $3='$TIME' - substr($3,0,10) {print}' joblist |awk '$3 > '$JOB_TIME' {print}'|tee -a nb_usr_2hr.out
#	echo -e "Jobs Running above 999GB Memory:" >>nb_usr_2hr.out
#	awk '$1 > '$MEM_TH', $3='$TIME' - substr($3,0,10) {print}' joblist|tee -a nb_usr_2hr.out
#else
#	exit 0;
#fi

if [ 125 -lt `wc -c< nb_usr.out` ]; then

echo -e "\n\nRecommended Action: Please check the above jobs for any performnce issues or query optimization possiblities,
it is also possible that these are slow jobs but they are not consuming much cluster resources,
or job is about to complete ie. above 95% completed. In such cases do not kill these job(s).\n\n">> nb_usr.out

mailx -S smtp="10.86.1.25:25" -r svc-awor-bdppmon@hgst.com -s "Non Batch User Applications running > 2Hrs" $CONTACT < nb_usr.out
#echo "An email was sent to $CONTACT"
sleep 2
grep ^job /home/svc-awor-bdppmon/nb_usr.out> /home/svc-awor-bdppmon/log/usr2HrQuerymon.log

else

exit 0
fi