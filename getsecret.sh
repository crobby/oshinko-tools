oc describe secret $(oc get serviceaccount oshinko -o json | json secrets | json 0 | json name) | grep "token:" | cut -f3
