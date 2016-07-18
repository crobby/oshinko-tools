#!/bin/sh

# $1 is the docker repo
# $2 openshift project (default is testproject)
# $3 server template (currently assumes you're in the oshinko-rest dir, which probably isn't true for anyone but me

REPO=$1
PROJECT=${2:-testproject}
TEMPLATE=${3:-tools/server-ui-template.yaml}

IPADDR=`hostname  -I | cut -f1 -d' '`

oc process -f $TEMPLATE -v OSHINKO_CLUSTER_IMAGE=$REPO/$PROJECT/oshinko-spark,OSHINKO_WEB_IMAGE=$REPO/$PROJECT/oshinko-web,OSHINKO_SERVER_IMAGE=$REPO/$PROJECT/oshinko-rest,OSHINKO_WEB_EXTERNAL_IP=oshinkoweb.$IPADDR.xip.io > server-ui-template.json


oc create -f server-ui-template.json
