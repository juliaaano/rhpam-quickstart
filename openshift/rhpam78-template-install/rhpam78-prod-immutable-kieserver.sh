#!/bin/bash

set -euo pipefail

echo "-------------------------------------------------------------------------------"
echo "RHPAM PROD IMMUTABLE Template Install"
echo "-------------------------------------------------------------------------------"

NAMESPACE=${1:-"rhpam"}

oc get imagestreamtag -n openshift | grep rhpam-kieserver | grep 7.8

oc new-project $NAMESPACE

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

oc apply -f rhpam78-image-streams.yaml

KEYSTORE_PWD=jkspassword
rm -f keystore.jks
keytool -noprompt -genkeypair -alias jboss -keypass $KEYSTORE_PWD -keyalg RSA -keystore keystore.jks -storepass $KEYSTORE_PWD --dname "CN=jsmith,OU=Engineering,O=mycompany.com,L=Raleigh,S=NC,C=US"
oc create secret generic kieserver-app-secret --from-file=keystore.jks

oc create secret generic rhpam-credentials --from-literal=KIE_ADMIN_USER=adminUser --from-literal=KIE_ADMIN_PWD=password

oc new-app -f rhpam78-prod-immutable-kieserver.yaml \
-p IMAGE_STREAM_NAMESPACE=$NAMESPACE \
-p KIE_SERVER_HTTPS_SECRET="kieserver-app-secret" \
-p KIE_SERVER_HTTPS_PASSWORD=$KEYSTORE_PWD \
-p CREDENTIALS_SECRET="rhpam-credentials" \
-p APPLICATION_NAME="rhpmqckstrt" \
-p KIE_SERVER_CONTAINER_DEPLOYMENT="rhpam-quickstart=com.juliaaano:rhpam-kjar:1.0.0-SNAPSHOT" \
-p SOURCE_REPOSITORY_URL="https://github.com/juliaaano/rhpam-quickstart" \
-p SOURCE_REPOSITORY_REF="master" \
-p CONTEXT_DIR="rhpam-kjar"

echo "end of script"
