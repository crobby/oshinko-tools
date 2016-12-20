#!/bin/sh

oc login -u developer -p test
TOKEN=`oc whoami -t`

oc login -u system:admin > /dev/null
oc project default > /dev/null 2>&1
REGIP=`oc get svc docker-registry | grep docker-registry | sed 's/\s\+/ /g' | cut -d' ' -f2`
REPO=$REGIP:5000

docker login -u developer -e me@mine.com -p $TOKEN $REPO
