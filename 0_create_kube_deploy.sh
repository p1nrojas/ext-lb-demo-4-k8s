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


echo "$(date -R) Remove deployment and service $APP_KUBE to recreate it"
ssh root@$K8S_CLUSTER kubectl delete -f $APP_YAML
ssh root@$K8S_CLUSTER kubectl delete service $APP_KUBE
echo "$(date -R) Sleep 15 seconds"
sleep 15
ssh root@$K8S_CLUSTER kubectl get all
echo "$(date -R) Starting to create deployment and services $APP_KUBE again"
echo "$(date -R) ssh root@$K8S_CLUSTER kubectl create -f $APP_YAML"
ssh root@$K8S_CLUSTER kubectl create -f $APP_YAML
sleep 3
echo "$(date -R) ssh root@$K8S_CLUSTER kubectl expose deployment $APP_KUBE --target-port=8080 --type=LoadBalancer"
ssh root@$K8S_CLUSTER kubectl expose deployment $APP_KUBE --target-port=8080 --type=LoadBalancer
sleep 3
ssh root@$K8S_CLUSTER kubectl get deployment
ssh root@$K8S_CLUSTER kubectl get pod
echo "$(date -R) sleep 15 seconds"
sleep 15
ssh root@$K8S_CLUSTER kubectl get all
