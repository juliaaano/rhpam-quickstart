# Red Hat Process Automation Manager
[![ci](https://github.com/juliaaano/rhpam-quickstart/actions/workflows/ci.yml/badge.svg)](https://github.com/juliaaano/rhpam-quickstart/actions/workflows/ci.yml)

A collection of artifacts to get you started with Red Hat Process Automation Manager.

## Import and develop in Business Central

Use the URL of this repo in Business Central.

* The rhpam-kjar gets selected for import.
* There is a dependency on **rhpam-dependencies** and **rhpam-event-listener**, but they are available in Maven Central.
* For development, use the SNAPSHOT versions and build dependencies locally.

## Get started

Experiment Process Automation Manager in two flavors: **JBoss EAP** and **Spring Boot**.

#### JBoss EAP with Docker

```
$ docker-compose up --detach --force-recreate rhpam-jboss
$ docker-compose logs --follow rhpam-jboss
$ curl -i -u adminUser:password http://localhost:18080/services/rest/server
```

#### Spring Boot with Docker

```
$ docker-compose up --detach --force-recreate rhpam-springboot
$ docker-compose logs --follow rhpam-springboot
$ curl -i -u user:user http://localhost:18090/rest/server
```

## Build with Docker

Access to **registry.redhat.io** (docker login) is required to build the JBoss image.

```
$ docker build --file d.jboss.Dockerfile --tag ghcr.io/juliaaano/rhpam-jboss:local .
$ docker build --file d.springboot.Dockerfile --tag ghcr.io/juliaaano/rhpam-springboot:local .
```

## Postman

Enjoy a setup of automated tests with Postman/Newman.

Use Docker Compose to bring up the containers and then run:

```
$ POSTMAN_ENV=rhpam-container-jboss docker-compose run --rm postman
$ POSTMAN_ENV=rhpam-container-springboot docker-compose run --rm postman
```

## OpenShift Deployment

Installation via the **operator** or **templates** availabe inside the *openshift* folder.

### Setup Credentials

Requires a [registry.redhat.io](https://registry.redhat.io/) account for pulling the container images.

```
$ export RH_REGISTRY_USR=rh-username
$ export RH_REGISTRY_PWD=rh-password
```

### Operator

```
$ ./rhpam-operator-install.sh
$ oc create -f kieapp-immutable-quickstart.yaml
```

### Template

```
$ ./rhpam78-prod-immutable-kieserver.sh
```

## JBoss EAP Installation and Deployment

For the installation of Process Automation Manager, visit:

* https://github.com/juliaaano/rhpam-eap-ansible

## Develop with Java, Maven and Spring Boot

The rhpam-springboot app is a convenient wat to deploy the kjar and its assets.

See [rhpam-springboot](rhpam-springboot) for more info.
