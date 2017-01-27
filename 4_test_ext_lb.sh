#!/usr/bin/bash

## Settings
## author: pinrojas.com
## Sept 2016

if [ ! -f ./config.sh ]; then
    echo "$(date -R) ERROR: File config.sh not found!"
    exit 1
fi

source ./config.sh

HAP_IPADDR=`docker exec haproxy01 tail -1 /etc/hosts | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`

echo "$(date -R) Here we go!"

echo "$(date -R) NUAGE_CLIENT_DOCKER=$NUAGE_CLIENT_DOCKER"

docker ps --all | grep client01 > /dev/null 2>&1
if [ "$?" -eq 0 ]; then
   echo "$(date -R) client01 already exist, Destroying..." 
   docker stop client01
   docker rm client01
   sleep 5
fi

echo "$(date -R) Creating client01..."
echo "$(date -R) docker run $NUAGE_CLIENT_DOCKER --name=client01 centos /tmp/client/curl_10_tests.sh $HAP_IPADDR"
docker run $NUAGE_CLIENT_DOCKER --name=client01 centos /tmp/client/curl_10_tests.sh $HAP_IPADDR
sleep 2

docker ps | grep client01 > /dev/null 2>&1
if [ "$?" -eq 0 ]; then
   #docker logs client01 | sed "s/^/$(date -R) /g" 
   docker logs -f client01 
   #echo "$(date -R) Sleeping 5 seconds!"
   #sleep 5
   echo "$(date -R) removing container client01"
   docker rm client01
   echo "$(date -R) Done!"
else
   echo "$(date -R) Ups!, something happened"
   docker logs client01 | sed "s/^/$(date -R) /g"
   exit 1
fi


