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
SPARKMASTER="${CLUSTERNAME}:7077"

oc login -u oshinko -p oshinko
oc project oshinko

## using oc set env since setting it on the exec command wasn't working
echo Going to run run the following commands:
echo "oc set env dc/$WORKERDEPLOYMENT SPARK_USER=chad"

oc set env dc/$WORKERDEPLOYMENT SPARK_USER=chad
echo "Waiting $PAUSEFORENV seconds for environment variable update to go through"
sleep $PAUSEFORENV
WORKERPOD=`oc get pods | grep -m 1 "${CLUSTERNAME}-w" | sed 's/\s\+/ /g' | cut -d' ' -f1`
echo "Going to run smoke test on POD: $WORKERPOD"
echo "oc exec ${WORKERPOD} -- spark-submit --master spark://$SPARKMASTER  --class org.apache.spark.examples.SparkPi /opt/spark/examples/jars/spark-examples_2.11-2.0.0-preview.jar 100"

oc exec ${WORKERPOD} -- /opt/spark/bin/spark-submit --master spark://$SPARKMASTER  --class org.apache.spark.examples.SparkPi /opt/spark/examples/jars/spark-examples_2.11-2.0.0-preview.jar 100
