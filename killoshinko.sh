oc login -u oshinko -p oshinko
oc project oshinko

oc delete deploymentconfigs --all
oc delete services --all
oc delete pods --all
oc delete routes --all
oc delete jobs --all

