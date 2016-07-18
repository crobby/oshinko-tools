#!/bin/sh

# $1 is the docker repo
# $2 openshift project (default is testproject)


REPO=$1
PROJECT=${2:-testproject}

docker tag -f crobby/oshinko-web $REPO/$PROJECT/oshinko-web
docker tag -f crobby/oshinko-rest $REPO/$PROJECT/oshinko-rest
docker tag -f crobby/oshinko-spark $REPO/$PROJECT/oshinko-spark
docker push $REPO/$PROJECT/oshinko-web
docker push $REPO/$PROJECT/oshinko-rest
docker push $REPO/$PROJECT/oshinko-spark

