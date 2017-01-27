#!/usr/bin/env bash

K8S_CLUSTER=master.sdn.lab
APP_KUBE=oi-uol
APP_YAML=oi-uol-v1.yaml

NUAGE_HAPROXY_DOCKER="-d -i -t -e \
NUAGE-DOMAIN=Kubernetes -e \
NUAGE-ZONE=ext-zone -e \
NUAGE-NETWORK=lb01 -e \
NUAGE-ENTERPRISE=UOL-K8s -e \
NUAGE-USER=k8s --net=none -v \
/root/ext-lb-demo-4-k8s/haproxy-conf:/usr/local/etc/haproxy"

NUAGE_CLIENT_DOCKER="-d -i -t -e \
NUAGE-DOMAIN=Kubernetes -e \
NUAGE-ZONE=ext-zone -e \
NUAGE-NETWORK=client -e \
NUAGE-ENTERPRISE=UOL-K8s -e \
NUAGE-USER=k8s --net=none -v \
/root/ext-lb-demo-4-k8s/client:/tmp/client"


