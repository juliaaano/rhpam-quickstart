#!/bin/bash

set -euo pipefail

NAMESPACE=${1:-"rhpam"}

oc get imagestreamtag -n openshift | grep rhpam-kieserver | grep 7.7

oc new-project $NAMESPACE

if [ -z "${OCP_PULL_SECRET+x}" ]; then

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

oc apply -f rhpam77-image-streams.yaml

KEYSTORE_PWD=jkspassword
rm -f keystore.jks
keytool -noprompt -genkeypair -alias jboss -keypass $KEYSTORE_PWD -keyalg RSA -keystore keystore.jks -storepass $KEYSTORE_PWD --dname "CN=jsmith,OU=Engineering,O=mycompany.com,L=Raleigh,S=NC,C=US"
oc create secret generic kieserver-app-secret --from-file=keystore.jks

oc create secret generic rhpam-credentials --from-literal=KIE_ADMIN_USER=adminUser --from-literal=KIE_ADMIN_PWD=password

oc new-app -f rhpam77-prod-immutable-kieserver.yaml \
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
