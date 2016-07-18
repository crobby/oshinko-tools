#!/bin/sh

oc login -u system:admin > /dev/null
oc project default > /dev/null 2>&1
REGIP=`oc get svc docker-registry | grep docker-registry | sed 's/\s\+/ /g' | cut -d' ' -f2`
echo $REGIP:5000
