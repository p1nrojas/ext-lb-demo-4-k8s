#!/usr/bin/bash

## Settings
## author: pinrojas.com
## Sept 2016

NUAGE_HAPROXY_DOCKER="-d -i -t -e \
NUAGE-DOMAIN=Kubernetes03 -e \
NUAGE-ZONE=ext-docker -e \
NUAGE-NETWORK=haproxy -e\
NUAGE-ENTERPRISE=K8s_Lab -e \
NUAGE-USER=admin --net=none -v \
/root/haproxy-docker/haproxy-conf:/usr/local/etc/haproxy"
K8S_CLUSTER=10.10.10.17


## Here we go!
echo "$(date -R) Here we go!"
echo "$(date -R) Testing SSH connection to K8s Cluster node"

ssh -o ConnectTimeout=3 root@$K8S_CLUSTER exit
if [ "$?" -eq 0 ]; then
  echo "$(date -R) K8s Cluster $K8S_CLUSTER reached out. to the next step"
else
  echo "$(date -R) ERROR: Check connection to K8s Cluster $K8S_CLUSTE. Bye!"
  exit 1
fi


echo "$(date -R) NUAGE_HAPROXY_DOCKER=$NUAGE_HAPROXY_DOCKER"
echo "$(date -R) Creating ./haproxy-conf/haproxy.cfg"

cat ./haproxy.cfg-head > ./haproxy-conf/haproxy.cfg
ssh root@$K8S_CLUSTER kubectl get pods -l run=hello-world -o yaml | grep podIP | sed -e 's/ *podIP: *//g' | sed -e 's/^\(.*\)$/  server \1 \1:8080 check/g' >> ./haproxy-conf/haproxy.cfg
cat ./haproxy.cfg-tail >> ./haproxy-conf/haproxy.cfg

cat ./haproxy-conf/haproxy.cfg > /dev/null 2>&1
if [ "$?" -eq 0 ]; then
   echo "$(date -R) file ./haproxy-conf/haproxy.cfg has been created"
else
   echo "$(date -R) ERROR: file ./haproxy-conf/haproxy.cfg doesn't exist"
   exit 1
fi

docker ps --all | grep haproxy01 > /dev/null 2>&1
if [ "$?" -eq 0 ]; then
   echo "$(date -R) haproxy01 already exist, Destroying..." 
   docker stop haproxy01
   docker rm haproxy01
   sleep 5
fi

echo "$(date -R) Creating haproxy01..."
docker run $NUAGE_HAPROXY_DOCKER --name=haproxy01 haproxy
sleep 2
docker ps | grep haproxy01 > /dev/null 2>&1
if [ "$?" -eq 0 ]; then
   docker logs haproxy01 | sed "s/^/$(date -R) /g"
   echo "$(date -R) Done!"
else
   echo "$(date -R) Ups!, something happened"
   docker logs haproxy01 | sed "s/^/$(date -R) /g"
   exit 1
fi


