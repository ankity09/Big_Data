set -vx
ambari=/var/www/html/ambari/
hdp=/var/www/html/hdp/
hdp_u=/var/www/html/hdp_utils/HDP-UTILS-1.1.0.21/

mkdir -p /var/www/html/ambari
mkdir -p /var/www/html/hdp
mkdir -p /var/www/html/hdp_utils/HDP-UTILS-1.1.0.21

mv /root/ambari-2.4.1.0-centos6.tar /var/www/html/ambari
mv /root/HDP-2.5.3.0-centos6-rpm.tar /var/www/html/hdp
mv /root/HDP-UTILS-1.1.0.21-centos6.tar /var/www/html/hdp_utils/HDP-UTILS-1.1.0.21

(cd $ambari; tar -xvf $ambari/ambari-2.4.1.0-centos6.tar)
(cd $hdp; tar -xvf $hdp/HDP-2.5.3.0-centos6-rpm.tar)
(cd $hdp_u; tar -xvf $hdp_u/HDP-UTILS-1.1.0.21-centos6.tar)

cp /var/www/html/ambari/AMBARI-2.4.1.0/setup_repo.sh /var/www/html/hdp/HDP/
cp /var/www/html/ambari/AMBARI-2.4.1.0/setup_repo.sh /var/www/html/hdp_utils/HDP-UTILS-1.1.0.21/

sh /var/www/html/ambari/AMBARI-2.4.1.0/setup_repo.sh
sh /var/www/html/hdp/HDP/setup_repo.sh
sh /var/www/html/hdp_utils/HDP-UTILS-1.1.0.21/setup_repo.sh

rpm -ivh ambari-metrics-collector-2.4.1.0-22.x86_64.rpm
rpm -ivh ambari-metrics-common-2.4.1.0-22.noarch.rpm
rpm -ivh ambari-metrics-hadoop-sink-2.4.1.0-22.x86_64.rpm
rpm -ivh ambari-metrics-monitor-2.4.1.0-22.x86_64.rpm
rpm -ivh ambari-server-2.4.1.0-22.x86_64.rpm
rpm -ivh ambari-agent-2.4.1.0-22.x86_64.rpm
