#!/bin/sh

echo "Will untag all images for the registry specified in the parameter (ie:  172.30.33.245:5000)"

docker images | grep "$1" | sed 's/\s\+/ /g' | cut -d' ' -f1 | xargs docker rmi -f
