#!/bin/bash

## Settings
## author: pinrojas.com
## Sept 2016

if [ ! -f ./config.sh ]; then
    echo "$(date -R) ERROR: File config.sh not found!"
    exit 1
fi

source ./config.sh

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

while true
do
  echo "$(date -R) ssh root@$K8S_CLUSTER kubectl get all"
  ssh root@$K8S_CLUSTER kubectl get all
  echo "$(date -R) sleep 10 seconds"
  sleep 10
done

