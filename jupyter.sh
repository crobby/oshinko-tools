#!/bin/sh

oc login -u system:admin
oc adm policy add-scc-to-user anyuid -z default -n myproject
oc login -u developer -p p

oc new-app jupyter/all-spark-notebook:latest
oc expose svc/all-spark-notebook
