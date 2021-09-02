#
# This Dockerfile is divided in 3 stages:
# 1. Builder image for the KJAR.
# 2. Builder image for the executable Spring Boot fat jar.
# 3. Executable image with just the JDK and the app fat jar.
#
# dependency:go-offline does not resolve transitive BOM (from drools-bom), therefore '--offline' does not work.


### DEPENDENCIES BUILDER IMAGE ###
FROM docker.io/maven:3-jdk-11-slim as builder-deps

### Choose to build the dependencies or let them resolve from Maven Central.
### rhpam-dependencies
#COPY rhpam-dependencies/pom.xml /build/rhpam-dependencies/
#RUN mvn --batch-mode --file build/rhpam-dependencies/pom.xml install
### rhpam-event-listener
# COPY rhpam-event-listener/pom.xml /build/rhpam-event-listener/
# RUN mvn --batch-mode --file build/rhpam-event-listener/pom.xml dependency:go-offline
# COPY rhpam-event-listener/src /build/rhpam-event-listener/src/
# RUN mvn --batch-mode --define skipTests --file build/rhpam-event-listener/pom.xml install

### rhpam-kjar
COPY rhpam-kjar/pom.xml /build/rhpam-kjar/
RUN mvn --batch-mode --file build/rhpam-kjar/pom.xml dependency:go-offline
COPY rhpam-kjar/src /build/rhpam-kjar/src/
RUN mvn --batch-mode --define skipTests --file build/rhpam-kjar/pom.xml install


### APP BUILDER IMAGE ###
FROM docker.io/maven:3-jdk-11-slim as builder-app

COPY rhpam-springboot/pom.xml /build/
RUN mvn --batch-mode --file build/pom.xml dependency:go-offline

COPY rhpam-springboot/src /build/src/
RUN mvn --batch-mode --define skipTests --file build/pom.xml package \
    && mkdir app \
    && mv build/target/*.jar app/app.jar

COPY rhpam-springboot/rhpam-springboot.xml /app/


### EXECUTABLE IMAGE ###
FROM docker.io/openjdk:11-jre-slim

ARG CREATED_AT=none
ARG GITHUB_SHA=none

LABEL org.opencontainers.image.created="$CREATED_AT"
LABEL org.opencontainers.image.revision="$GITHUB_SHA"

LABEL org.opencontainers.image.title="RHPAM Quickstart Spring Boot"
LABEL org.opencontainers.image.description="Red Hat Process Automation Quickstart Application with KIE Server in Spring Boot."
LABEL org.opencontainers.image.url="https://github/juliaaano/rhpam-quickstart"
LABEL org.opencontainers.image.source="git@github.com:juliaaano/rhpam-quickstart"
LABEL org.opencontainers.image.documentation="https://github/juliaaano/rhpam-quickstart"
LABEL org.opencontainers.image.authors="juliaaano"
LABEL org.opencontainers.image.vendor="juliaaano"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="1.1.0"

COPY --from=builder-deps /root/.m2/repository /root/.m2/repository/
COPY --from=builder-app app app/

WORKDIR /app

EXPOSE 8090

CMD ["java", "-jar", "app.jar"]
