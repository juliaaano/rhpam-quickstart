# RHDM Spring Boot

Red Hat Decision Manager with Spring Boot.

This is an option of running the KIE Server without an application server like JBoss EAP.

It is expected the kjar and its dependencies to be found by Maven.

KIE container deployments are managed by rhdm-springboot.xml, which means the file must be present in the context directory where this application runs.

## Build dependencies
```
mvn --file ../rhdm-dependencies/pom.xml clean install
mvn --file ../rhdm-event-listener/pom.xml clean install
mvn --file ../rhdm-kjar/pom.xml clean install
```

## Spring Boot run
```
mvn spring-boot:run
```
