#!/bin/bash
set -x

# This script is for deploying oshinko into an already running cluster.
# It assumes a few things:
# * you have the following images in your local docker registry:
#   * oshinko-rest-server
#   * oshinko-webui
#   * openshift-spark
#   * daikon-pyspark
# * you have a file named "oshinko-deploy.yaml" in the current directory
# * you have reployed an openshift cluster with `oc cluster up` and have the
#   default `developer` account active
#
# Usage:
# $ oshinko-deploy.sh {route IP} {project name}
#
# route IP -- address to use in the exposed route information
# project name -- project to deploy oshinko into


if [ -z $1 ]
then
    echo "for the moment, pass me an IP address to use in the exposed route for oshinko-web, for example:"
    echo "./oshinko-deploy.sh 10.16.40.70 myproject"
    exit 1
fi
WEBROUTEIP=$1


if [ -z $2 ]
then
    echo "project name not supplied, for example:"
    echo "./oshinko-deploy.sh 10.16.40.70 myproject"
    exit 1
fi
PROJECT=$2

oc login -u system:admin
oc project default
REGISTRY=$(oc get service docker-registry --no-headers=true | awk -F ' ' '{print $2":"$4}' | sed "s,/TCP$,,")

# reset back to the default development account
oc login -u developer
oc project $PROJECT

# Wait for the registry to be fully up
r=1
while [ $r -ne 0 ]; do
    docker login -u $(oc whoami) -e "jack@jack.com" -p $(oc whoami -t) $REGISTRY
    r=$?
    sleep 1
done

docker tag oshinko-rest-server $REGISTRY/$PROJECT/oshinko-rest-server
docker push $REGISTRY/$PROJECT/oshinko-rest-server
docker tag oshinko-webui $REGISTRY/$PROJECT/oshinko-webui
docker push $REGISTRY/$PROJECT/oshinko-webui
docker tag openshift-spark $REGISTRY/$PROJECT/openshift-spark
docker push $REGISTRY/$PROJECT/openshift-spark
docker tag daikon-pyspark $REGISTRY/$PROJECT/daikon-pyspark
docker push $REGISTRY/$PROJECT/daikon-pyspark

# set up the oshinko service account
oc create sa oshinko -n $PROJECT
oc policy add-role-to-user admin system:serviceaccount:$PROJECT:oshinko -n $PROJECT

# process the standard oshinko template and launch it
oc process -f oshinko-deploy.yaml \
OSHINKO_SERVER_IMAGE=$REGISTRY/$PROJECT/oshinko-rest-server \
OSHINKO_CLUSTER_IMAGE=$REGISTRY/$PROJECT/openshift-spark \
OSHINKO_WEB_IMAGE=$REGISTRY/$PROJECT/oshinko-webui \
OSHINKO_WEB_EXTERNAL_IP=mywebui.$WEBROUTEIP.xip.io \
> oshinko-deploy-processed.json
oc create -f oshinko-deploy-processed.json -n $PROJECT
