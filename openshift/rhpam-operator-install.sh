#!/bin/bash

set -euo pipefail

NAMESPACE=${1:-"businessautomation"}

oc get packagemanifests -n openshift-marketplace | grep businessautomation

oc new-project $NAMESPACE

if [ -z $OCP_PULL_SECRET ]; then

echo "------------------------------------------------------------------------"
echo "OCP_PULL_SECRET not found. OpenShift secrets for image pull not created."
echo "------------------------------------------------------------------------"

else

cat <<EOF | oc apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: redhat-pull-secret
data:
  .dockerconfigjson: ${OCP_PULL_SECRET}
type: kubernetes.io/dockerconfigjson
EOF

oc secrets link default redhat-pull-secret --for=pull
oc secrets link builder redhat-pull-secret --for=pull

fi

cat <<EOF | oc apply -f -
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: businessautomation
  namespace: ${NAMESPACE}
spec:
  targetNamespaces:
  - ${NAMESPACE}
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: businessautomation-operator
  namespace: ${NAMESPACE}
spec:
  channel: stable
  name: businessautomation-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF

echo "end of script"
