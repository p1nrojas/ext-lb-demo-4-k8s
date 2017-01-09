#!/bin/bash

## Settings
## author: pinrojas.com
## Sept 2016

K8S_CLUSTER=10.10.10.17
APP_KUBE=hello-world
APP_YAML=hello.yaml


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


SERVICE_IP=`ssh root@$K8S_CLUSTER kubectl get services | grep "hello-world" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`

echo "$(date -R) service IP=$SERVICE_IP"
  echo "$(date -R) curl http://$SERVICE_IP:8080"

while true
do
  ssh root@$K8S_CLUSTER curl -s http://$SERVICE_IP:8080
  sleep 1
done

