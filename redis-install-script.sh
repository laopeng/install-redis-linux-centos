#!/bin/bash
# From here: https://github.com/saxenap/install-redis-amazon-linux-centos
# Download from http://download.redis.io/releases/
# Uses redis-server init script from https://raw.github.com/saxenap/install-redis-amazon-linux-centos/master/redis-server
###############################################
# To use: 
# wget https://raw.github.com/saxenap/install-redis-amazon-linux-centos/master/redis-install-script.sh
# chmod 777 redis-install-script.sh
# ./redis-install-script.sh
###############################################
echo "*****************************************"
echo " 1. Prerequisites: Install updates, set time zones, install GCC and make"
echo "*****************************************"
# yum -y update
# ln -sf /usr/share/zoneinfo/America/Indianapolis /etc/localtime
yum -y install gcc gcc-c++ make 
echo "*****************************************"
echo " 2. Download, Untar and Make Redis stable"
echo "*****************************************"
[ ! -d /root/soft ] && mkdir /root/soft
cd /root/soft 
wget http://download.redis.io/releases/redis-stable.tar.gz
tar xzf redis-stable.tar.gz
cd redis-stable
make 
make install
echo "*****************************************"
echo " 3. Create Directories and Copy Redis Files"
echo "*****************************************"
mkdir /etc/redis /var/lib/redis
cp src/redis-server src/redis-cli /usr/local/bin
cp redis.conf /etc/redis
echo "*****************************************"
echo " 4. Configure Redis.Conf"
echo "*****************************************"
echo " Edit redis.conf as follows:"
echo " 1: ... daemonize yes"
echo " 2: ... bind 127.0.0.1"
echo " 3: ... dir /var/lib/redis"
echo " 4: ... loglevel notice"
echo " 5: ... logfile /var/log/redis.log"
echo "*****************************************"
sed -e "s/^daemonize no$/daemonize yes/" -e "s/^# bind 127.0.0.1$/bind 127.0.0.1/" -e "s/^dir \.\//dir \/var\/lib\/redis\//" -e "s/^loglevel verbose$/loglevel notice/" -e "s/^logfile stdout$/logfile \/var\/log\/redis.log/" redis.conf > /etc/redis/redis.conf
echo "rename-command CONFIG """ >> /etc/redis/redis.conf
echo "rename-command FLUSHALL """ >> /etc/redis/redis.conf
echo "rename-command FLUSHDB """ >> /etc/redis/redis.conf
echo "*****************************************"
echo " 5. Download init Script"
echo "*****************************************"
wget https://raw.githubusercontent.com/laopeng/install-redis-linux-centos/master/redis-server --no-check-certificate
echo "*****************************************"
echo " 6. Move and Configure Redis-Server"
echo "*****************************************"
mv redis-server /etc/init.d
chmod 755 /etc/init.d/redis-server
echo "*****************************************"
echo " 7. Auto-Enable Redis-Server"
echo "*****************************************"
chkconfig --add redis-server
chkconfig --level 345 redis-server on
echo "*****************************************"
echo " 8. Start Redis Server"
echo "*****************************************"
service redis-server start
echo "*****************************************"
echo " Installation Complete!"
echo " You can test your redis installation using the redis console:"
echo "   $ src/redis-cli"
echo "   redis> ping"
echo "   PONG"
echo "*****************************************"
echo " Following changes have been made in redis.config:"
echo " 1: ... daemonize yes"
echo " 2: ... bind 127.0.0.1"
echo " 3: ... dir /var/lib/redis"
echo " 4: ... loglevel notice"
echo " 5: ... logfile /var/log/redis.log"
echo "*****************************************"
read -p "Press [Enter] to continue..."
