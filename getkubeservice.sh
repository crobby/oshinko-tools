OC_USER=`oc whoami`
oc login -u system:admin > /dev/null && oc project default > /dev/null && oc describe service kubernetes | grep "IP:" | cut -f4
oc login -u $OC_USER -p fakepass > /dev/null
