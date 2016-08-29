#!/bin/sh
### 1. Give the routeable IP that will be used for the webui xip.io address
### 2. Give the location of the server-ui-template.yaml that you want to use


oc login -u system:admin > /dev/null
oc project default > /dev/null 2>&1
REGIP=`oc get svc docker-registry | grep docker-registry | sed 's/\s\+/ /g' | cut -d' ' -f2`
REGISTRY=${REGIP}:5000
WEBROUTEIP=$1
TEMPLATE=$2
PROJECT=$3

oc login -u croberts -p croberts
oc project $PROJECT


#OSHINKO_CLUSTER_IMAGE=$REGISTRY/$PROJECT/xpaas-spark \

oc process -f $2 \
OSHINKO_SERVER_IMAGE=$REGISTRY/$PROJECT/oshinko-rest \
OSHINKO_CLUSTER_IMAGE=$REGISTRY/$PROJECT/openshift-spark \
OSHINKO_WEB_IMAGE=$REGISTRY/$PROJECT/oshinko-web \
OSHINKO_WEB_EXTERNAL_IP=mywebui.$WEBROUTEIP.xip.io > oshinko-template.json
oc create -f oshinko-template.json

REST_SERVICE=`oc get svc | grep oshinko-rest | cut -d' ' -f1`

oc expose service $REST_SERVICE --hostname=oshinko-rest.$WEBROUTEIP.xip.io
oc create -f ../oshinko-s2i/pyspark/pysparkbuilddc.json 
oc create -f ../oshinko-s2i/pyspark/pysparkbuild.json
oc create -f ../oshinko-s2i/pyspark/pysparkdc.json
oc create -f ../oshinko-s2i/pyspark/pysparkjob.json
