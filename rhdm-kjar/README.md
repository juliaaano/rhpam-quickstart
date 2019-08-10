# RHDM quickstart kjar

Red Hat Decision Manager project quickstart kjar.
* Use it with Decision Central.
* Suitable for KIE Server deployments.
* Check out the different types of rule assets.

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
