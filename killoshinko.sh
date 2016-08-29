oc login -u croberts -p croberts
oc project croshinko

oc delete deploymentconfigs --all
oc delete services --all
oc delete pods --all
oc delete routes --all
oc delete jobs --all

