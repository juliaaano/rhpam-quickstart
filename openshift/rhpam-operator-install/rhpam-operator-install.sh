#!/bin/bash

set -euo pipefail

echo "-------------------------------------------------------------------------------"
echo "RHPAM Operator Install"
echo "-------------------------------------------------------------------------------"

NAMESPACE=${1:-"businessautomation"}

oc get packagemanifests -n openshift-marketplace | grep businessautomation

#oc new-project $NAMESPACE

if [ -z "${RH_REGISTRY_USR+x}" -o -z "${RH_REGISTRY_PWD+x}" ]; then

echo "-------------------------------------------------------------------------------"
echo "RH_REGISTRY_USR or RH_REGISTRY_PWD not found."
echo "OpenShift secrets for image pull not created."
echo "-------------------------------------------------------------------------------"

else

oc create secret docker-registry redhat-pull-secret \
    --docker-server=registry.redhat.io \
    --docker-username=${RH_REGISTRY_USR} \
    --docker-password=${RH_REGISTRY_PWD}

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
