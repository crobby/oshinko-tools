oc login -u developer -p p
oc new-project webui
oc create sa oshinko
oc policy add-role-to-user admin system:serviceaccount:webui:oshinko -n webui
oc create -f server-ui-template.yaml 
oc create -f ui-template.yaml
