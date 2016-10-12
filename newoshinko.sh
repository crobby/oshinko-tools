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
oc new-project oshinko

oc login -u system:admin > /dev/null
oadm policy add-role-to-user system:image-builder oshinko
oc policy add-role-to-user admin -z oshinko

oc login -u oshinko -p oshinko
oc project oshinko


#OSHINKO_CLUSTER_IMAGE=$REGISTRY/oshinko/xpaas-spark


oc process -f $2 \
OSHINKO_SERVER_IMAGE=$REGISTRY/oshinko/oshinko-rest-server \
OSHINKO_CLUSTER_IMAGE=$REGISTRY/oshinko/openshift-spark \
OSHINKO_WEB_IMAGE=$REGISTRY/oshinko/oshinko-webui \
OSHINKO_WEB_ROUTE_HOSTNAME=mywebui.$WEBROUTEIP.xip.io > oshinko-template.json
oc create -f oshinko-template.json

REST_SERVICE=`oc get svc | grep oshinko-rest | cut -d' ' -f1`

#oc expose service $REST_SERVICE --hostname=oshinko-rest.$WEBROUTEIP.xip.io
oc create route edge --service=$REST_SERVICE --hostname=oshinko-rest.$WEBROUTEIP.xip.io
oc create -f ../oshinko-s2i/pyspark/pysparkbuilddc.json 
oc create -f ../oshinko-s2i/pyspark/pysparkbuild.json
oc create -f ../oshinko-s2i/pyspark/pysparkdc.json
oc create -f ../oshinko-s2i/pyspark/pysparkjob.json

