oc cluster up --host-config-dir=/home/croberts/originconfig --use-existing-config

oc login -u oshinko -p oshinko
oc new-project oshinko
oc create sa oshinko
oc policy add-role-to-user admin -z oshinko
