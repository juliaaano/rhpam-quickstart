# This Dockerfile is divided in two stages, the first is a builder for the KJAR
# and the second is the executable image (KIE Server + KJAR).
# Maven 'dependency:go-offline' followed by '--offline install' is used to leverage
# the Docker caching so builds are faster after the first time.


### BUILDER IMAGE ###
FROM maven:3-jdk-8-slim as builder

COPY rhpam-dependencies/pom.xml /build/rhpam-dependencies/
RUN mvn --file build/rhpam-dependencies/pom.xml --batch-mode install

COPY rhpam-event-listener/pom.xml /build/rhpam-event-listener/
RUN mvn --file build/rhpam-event-listener/pom.xml --batch-mode dependency:go-offline
# dependency:go-offline does not resolve transitive BOM (from drools-bom), therefore 'install'is required.
RUN mvn --file build/rhpam-event-listener/pom.xml --batch-mode install

COPY rhpam-event-listener/src /build/rhpam-event-listener/src/
RUN mvn --file build/rhpam-event-listener/pom.xml --batch-mode --offline install -DskipTests

COPY rhpam-kjar/pom.xml /build/rhpam-kjar/
RUN mvn --file build/rhpam-kjar/pom.xml --batch-mode dependency:go-offline

COPY rhpam-kjar/src /build/rhpam-kjar/src/
RUN mvn --file build/rhpam-kjar/pom.xml --batch-mode --offline install -DskipTests


### EXECUTABLE IMAGE ###
FROM registry.redhat.io/rhpam-7/rhpam-kieserver-rhel8:7.7.1

COPY --from=builder /root/.m2/repository /home/jboss/.m2/repository/

USER root
RUN chown jboss -R /home/jboss/.m2/repository
USER jboss

ENV KIE_ADMIN_USER=user KIE_ADMIN_PWD=password
ENV KIE_SERVER_CONTAINER_DEPLOYMENT=rhpam-quickstart=com.juliaaano:rhpam-kjar:1.0.0-SNAPSHOT
