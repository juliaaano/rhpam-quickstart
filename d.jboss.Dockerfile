# This Dockerfile is divided in two stages, the first is a builder for the KJAR
# and the second is the executable image (KIE Server + KJAR).
#
# dependency:go-offline does not resolve transitive BOM (from drools-bom), therefore '--offline' does not work.

### BUILDER IMAGE ###
FROM docker.io/maven:3-openjdk-11-slim as builder

ARG MVN="mvn --show-version --batch-mode"

### rhpam-dependencies
COPY rhpam-dependencies/pom.xml /build/rhpam-dependencies/
RUN $MVN --file build/rhpam-dependencies/pom.xml install

### rhpam-event-listener
COPY rhpam-event-listener/pom.xml /build/rhpam-event-listener/
RUN $MVN --file build/rhpam-event-listener/pom.xml dependency:go-offline
COPY rhpam-event-listener/src /build/rhpam-event-listener/src/
RUN $MVN --file build/rhpam-event-listener/pom.xml install

### rhpam-kjar
COPY rhpam-kjar/pom.xml /build/rhpam-kjar/
RUN $MVN --file build/rhpam-kjar/pom.xml dependency:go-offline
COPY rhpam-kjar/src /build/rhpam-kjar/src/
RUN $MVN --file build/rhpam-kjar/pom.xml install


### EXECUTABLE IMAGE ###
FROM registry.redhat.io/rhpam-7/rhpam-kieserver-rhel8:7.11.1

COPY --from=builder /root/.m2/repository /home/jboss/.m2/repository/

USER root
RUN chown jboss -R /home/jboss/.m2/repository
USER jboss

ENV KIE_ADMIN_USER=adminUser KIE_ADMIN_PWD=password
ENV KIE_SERVER_CONTAINER_DEPLOYMENT=rhpam-quickstart=com.juliaaano:rhpam-kjar:1.0.0-SNAPSHOT
