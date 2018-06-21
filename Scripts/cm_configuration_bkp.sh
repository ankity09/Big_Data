set -vx
DATE=`date +"%Y-%m-%d"`
MAIL=Name@mail.com
DST_PATH=/path/for/destination/Configurations.json
SERVER1=server.name@realm.com
DSTPTH=/var/www/html/HGST/CM_Config_Backup/
LOGPTH=/home/svc-awor-bdppmon/


CONFIG_FILE=`ssh username@$SERVER1 curl -k  -u cm_id:cm_pass "https://10.240.0.169:7180/api/v9/cm/deployment" > /path/to/file/BDP_Production.jon`


ssh username@$SERVER1 cat /path/to/file/BDP_Production.json > $DSTPTH/BDP_Production.json
echo -e "$LATEST_FILE is copied to $DSTPTH"

echo "CM Configuration Backup completed and saved on http://10.240.4.16/path/for/destination/" | mailx -s "CM Configuration backup completed" -S smtp="10.86.1.25:25" -r user@mail.com $MAIL