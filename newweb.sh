OSHINKO_WEB_DIR=$1

oc login -u system:admin > /dev/null
oc project default > /dev/null 2>&1
REGIP=`oc get svc docker-registry | grep docker-registry | sed 's/\s\+/ /g' | cut -d' ' -f2`
REGISTRY=${REGIP}:5000

oc login -u oshinko -p oshinko
oc project oshinko
TOKEN=`oc whoami -t`
docker login -u oshinko -e me@mine.com -p $TOKEN $REGISTRY

DEPLOYMENTCONFIG=`oc get deploymentconfigs | grep oshinko-web | sed 's/\s\+/ /g' | cut -d' ' -f1`

pushd $OSHINKO_WEB_DIR
docker build -t oshinko-webui .
docker tag -f oshinko-web $REGISTRY/oshinko/oshinko-webui
docker push $REGISTRY/oshinko/oshinko-webui
popd

oc deploy $DEPLOYMENTCONFIG --latest -n oshinko
oc set env dc/$DEPLOYMENTCONFIG NEWBUILD=1
