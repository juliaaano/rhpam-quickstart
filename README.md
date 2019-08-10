# Red Hat Decision Manager 

A collection of RHDM artifacts to serve as a template for new projects.

## Build and run with Docker

### JBoss EAP
```
docker build --file d.jboss.Dockerfile --tag juliaaano/rhdm-jboss:local .
docker run --rm --name rhdm-jboss --detach --publish 18080:8080 juliaaano/rhdm-jboss:local
docker logs --follow rhdm-jboss
```

### Spring Boot
```
docker build --file d.springboot.Dockerfile --tag juliaaano/rhdm-springboot:local .
docker run --rm --name rhdm-springboot --detach --publish 18090:8090 juliaaano/rhdm-springboot:local
docker logs --follow rhdm-springboot
```

### Running both with Docker Compose
```
docker-compose up --detach --force-recreate rhdm-jboss rhdm-springboot
docker-compose logs --follow rhdm-jboss rhdm-springboot
```

### Postman
Once the system is up and running with Docker Compose:
```
docker-compose run --rm postman
```

## Maven Spring Boot
See [rhdm-springboot](rhdm-springboot).
