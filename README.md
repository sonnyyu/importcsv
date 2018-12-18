sudo apt-get update -y && apt-get upgrade -y

export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y install mysql-server
Of course, it leaves you with a blank root password - so you'll want to run something like

mysqladmin -u root password mysecretpasswordgoeshere


#sudo apt-get install mysql-server -y
#sudo mysql_secure_installation

systemctl status mysql.service

Install Splunk:
sudo apt-get update -y && apt-get upgrade -y
cd ~
#wget -O splunk-7.2.1-be11b2c46e23-linux-2.6-amd64.deb 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.2.1&product=splunk&filename=splunk-7.2.1-be11b2c46e23-linux-2.6-amd64.deb&wget=true'

wget http://10.145.88.160/splunk-7.2.1-be11b2c46e23-linux-2.6-amd64.deb

dpkg -i splunk-7.2.1-be11b2c46e23-linux-2.6-amd64.deb

cd /opt/splunk/bin

./splunk start --accept-license

./splunk enable boot-start

Install Splunk Security Essentials :
Install Splunk DB Connect :


apt-get update && apt-get upgrade
apt-get install software-properties-common -y 
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install oracle-java8-installer -y

java -version

update-alternatives --config java
nano /etc/environment
JAVA_HOME="/usr/lib/jvm/java-8-oracle/jre/bin/java"

source /etc/environment

echo $JAVA_HOME


sudo dpkg-reconfigure tzdata


cp mysql-connector-java-8.0.13.jar  /opt/splunk/etc/apps/splunk_app_db_connect/drivers/

