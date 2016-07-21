#!/bin/sh
### 1. Give the routeable IP that will be used for the webui xip.io address
### 2. Give the location of the server-ui-template.yaml that you want to use


oc login -u system:admin > /dev/null
oc project default > /dev/null 2>&1
REGIP=`oc get svc docker-registry | grep docker-registry | sed 's/\s\+/ /g' | cut -d' ' -f2`
REGISTRY=${REGIP}:5000
WEBROUTEIP=$1
TEMPLATE=$2

oc login -u oshinko -p oshinko
oc project oshinko

oc process -f $2 \
OSHINKO_SERVER_IMAGE=$REGISTRY/oshinko/oshinko-rest-server \
OSHINKO_CLUSTER_IMAGE=$REGISTRY/oshinko/openshift-spark \
OSHINKO_WEB_IMAGE=$REGISTRY/oshinko/oshinko-webui \
OSHINKO_WEB_EXTERNAL_IP=mywebui.$WEBROUTEIP.xip.io > oshinko-template.json
oc create -f oshinko-template.json

