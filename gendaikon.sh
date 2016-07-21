#!/bin/sh

# $1 openshift project (default is oshinko)
# $2 server template (currently assumes default one in this dir) 

oc login -u system:admin > /dev/null
oc project default > /dev/null 2>&1
REGIP=`oc get svc docker-registry | grep docker-registry | sed 's/\s\+/ /g' | cut -d' ' -f2`
REPO=$REGIP:5000



PROJECT=${1:-oshinko}
TEMPLATE=${2:-server-ui-template.yaml}


oc login -u oshinko -p test
oc project $PROJECT

IPADDR=`hostname  -I | cut -f1 -d' '`

oc process -f $TEMPLATE -v OSHINKO_CLUSTER_IMAGE=$REPO/$PROJECT/oshinko-spark,OSHINKO_WEB_IMAGE=$REPO/$PROJECT/oshinko-web,OSHINKO_SERVER_IMAGE=$REPO/$PROJECT/oshinko-rest,OSHINKO_WEB_EXTERNAL_IP=oshinkoweb.$IPADDR.xip.io > server-ui-template.json


cat <<EOF > sa.json
{
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
      "name": "oshinko"
    }
}
EOF
oc create -f sa.json
oc policy add-role-to-user admin system:serviceaccount:$PROJECT:oshinko -n $PROJECT



oc create -f server-ui-template.json
