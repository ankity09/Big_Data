#!/bin/bash

#RCVR="HM230067@teradata.com musharaf.syed@hgst.com Matt.Bigelow@hgst.com"
RCVR=HM230067@teradata.com
#RCVR=shashank.rathore@teradata.com
if [ $(ls host.ip) == host.ip ]; then
	echo " "
else
	#awk '{print $2}' /etc/hosts >host.ip
	echo "host.ip created"
fi

for i in $(cat host.ip)
	do
	if ping -c 1 $i &> /dev/null; then

                ssh svc-awor-bdppmon@$i 'if [ -s /etc/krb5.conf ] ;then echo "exist on $(hostname)" &> /dev/null; else echo "does not Exist on $(hostname)"|tee -a FixLink.txt; fi'

	else
                echo "unable to ping $i"|tee -a FixLink.txt

	fi
done

if [ -s FixLink.txt ]
then
       cat FixLink.txt|mailx -S smtp="10.86.1.25:25" -r svc-awor-bdppmon@wdc.com -s "Kerberos Symbolic Link Broken " $RCVR 
       rm -f FixLink.txt
else
	rm -f FixLink.txt
	echo "All nodes Passed"
	exit 0
fi