#!/bin/sh

PROJECT=${1:-testproject}

oc project $PROJECT

oc delete service --all
oc delete route --all
oc delete pod --all
oc delete deploymentconfig --all

