oc login -u system:admin
oc project oshinko
oc create -f limits.json

oc describe limits limits

