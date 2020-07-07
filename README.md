# Red Hat Process Automation Manager
[![Build Status](https://travis-ci.com/juliaaano/rhpam-quickstart.svg)](https://travis-ci.com/juliaaano/rhpam-quickstart)

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
docker-compose up --detach --force-recreate rhpam-jboss
docker-compose logs --follow rhpam-jboss
curl -i -H 'Authorization: Basic dXNlcjpwYXNzd29yZA==' http://localhost:18080/services/rest/server
```

#### Spring Boot with Docker

```
docker-compose up --detach --force-recreate rhpam-springboot
docker-compose logs --follow rhpam-springboot
curl -i -H 'Authorization: Basic dXNlcjp1c2Vy' http://localhost:18090/rest/server
```

## Build with Docker

Access to **registry.redhat.io** (docker login) is required to build the JBoss image.

```
docker build --file d.jboss.Dockerfile --tag juliaaano/rhpam-jboss .
docker build --file d.springboot.Dockerfile --tag juliaaano/rhpam-springboot .
```

## Postman

Enjoy a setup of automated tests with Postman/Newman.

Use Docker Compose to bring up the containers and then run:

```
POSTMAN_ENV=rhpam-container-jboss docker-compose run --rm postman
POSTMAN_ENV=rhpam-springboot docker-compose run --rm postman
```

## Install Process Automation Manager

For the installation of Process Automation Manager, visit:

* https://github.com/juliaaano/rhpam-eap-ansible

## Develop with Java, Maven and Spring Boot

The rhpam-springboot app is a convenient wat to deploy the kjar and its assets.

See [rhpam-springboot](rhpam-springboot) for more info.
