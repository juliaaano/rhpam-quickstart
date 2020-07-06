# RHPAM Spring Boot

Red Hat Process Automation Manager with Spring Boot.

This is an option of running the KIE Server without an application server like JBoss EAP.

It is expected the kjar and its dependencies to be found by Maven.

KIE container deployments are managed by rhpam-springboot.xml, which means the file must be present in the context directory where this application runs.

## Build dependencies
```
mvn --file ../rhpam-dependencies/pom.xml clean install
mvn --file ../rhpam-event-listener/pom.xml clean install
mvn --file ../rhpam-kjar/pom.xml clean install
```

## Spring Boot run
```
mvn spring-boot:run
```
