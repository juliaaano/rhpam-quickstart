# Red Hat Decision Manager 

A collection of RHDM artifacts to serve as a template for new projects.

## Maven Build
```
./build-all.sh
```

## Docker
```
docker build --tag juliaaano/rhdm-quickstart:local .
docker run --rm --name rhdm-quickstart --detach --publish 18080:8080 juliaaano/rhdm-quickstart:local
docker logs --follow rhdm-quickstart
```
