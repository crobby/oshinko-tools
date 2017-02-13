#!/bin/sh

## Just pass the cluster name to this script
#  it will login and figure out the pods/deployments and stuff
#  and then it will run a quick spark example job on one of the
#  worker nodes.
# the optional second argument is the length of pause from the
# issuing of the env var setting to the actual running of the
# test


CLUSTERNAME=$1
PAUSEFORENV=${2:-60}
WORKERDEPLOYMENT="${CLUSTERNAME}-w"
#SPARKMASTER="${CLUSTERNAME}:7077"

oc login -u developer -p dev
oc project myproject

## using oc set env since setting it on the exec command wasn't working
#echo Going to run run the following commands:
#echo "oc set env dc/$WORKERDEPLOYMENT SPARK_USER=chad"

#oc set env dc/$WORKERDEPLOYMENT SPARK_USER=chad
echo "Waiting $PAUSEFORENV seconds"
sleep $PAUSEFORENV
WORKERPOD=`oc get pods | grep -m 1 "${CLUSTERNAME}-w" | sed 's/\s\+/ /g' | cut -d' ' -f1`
echo "Going to run smoke test on POD: $WORKERPOD"
oc cp ./runit.sh $WORKERPOD:/tmp/
echo "oc exec ${WORKERPOD} -- /tmp/runit.sh"

oc exec ${WORKERPOD} -- /tmp/runit.sh

