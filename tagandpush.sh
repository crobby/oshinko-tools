#!/bin/sh

# $1 openshift project (default is oshinko)


PROJECT=${1:-oshinko}

oc login -u system:admin > /dev/null
oc project default > /dev/null 2>&1
REGIP=`oc get svc docker-registry | grep docker-registry | sed 's/\s\+/ /g' | cut -d' ' -f2`
REPO=$REGIP:5000

oc login -u oshinko -p test
TOKEN=`oc whoami -t`

oc new-project $PROJECT
oc login -u system:admin
oc project default
oadm policy add-role-to-user system:registry oshinko
oadm policy add-role-to-user admin oshinko -n $PROJECT     
oadm policy add-role-to-user system:image-builder oshinko


docker login -u oshinko -e me@mine.com -p $TOKEN $REPO


## uncomment this if you want to be able to just pass in your own repo
# REPO = $2 

#oc login -u croberts -p test
#oc project $PROJECT

docker pull crobby/oshinko-web
docker pull crobby/oshinko-rest
docker pull crobby/oshinko-spark
docker tag -f crobby/oshinko-web $REPO/$PROJECT/oshinko-web
docker tag -f crobby/oshinko-rest $REPO/$PROJECT/oshinko-rest
docker tag -f crobby/oshinko-spark $REPO/$PROJECT/oshinko-spark
docker push $REPO/$PROJECT/oshinko-web
docker push $REPO/$PROJECT/oshinko-rest
docker push $REPO/$PROJECT/oshinko-spark

