# RHDM Quickstart

Red Hat Decision Manager project quickstart.
* Ideal to import into Decision Central.
* Suitable for KIE Server deployments in JBoss EAP.

## Dependencies
Build and install rhdm-dependencies and rhdm-event-listener Maven artifacts found in parent directory.

## Maven
```
mvn clean install
```

## Maven deploy
```
mvn deploy --activate-profiles deploy
```
Without distribution management:
```
mvn deploy -DaltDeploymentRepository='nexus::default::http://user:password@maven-repo-host/repo-path/'
```
