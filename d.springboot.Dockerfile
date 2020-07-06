# This Dockerfile is divided in 3 stages:
# 1. Builder image for the KJAR.
# 2. Builder image for the executable Spring Boot fat jar.
# 3. Executable image with just the JDK and the app fat jar.
# Maven 'dependency:go-offline' followed by '--offline install' is used to leverage
# the Docker caching so builds are faster after the first time.


### DEPENDENCIES BUILDER IMAGE ###
FROM maven:3-jdk-8-slim as builder-deps

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


### APP BUILDER IMAGE ###
FROM maven:3-jdk-8-slim as builder-app

COPY rhpam-springboot/pom.xml /build/

RUN mvn --file build/pom.xml --batch-mode dependency:go-offline

COPY rhpam-springboot/src /build/src/

RUN mvn --file build/pom.xml --batch-mode --offline package -DskipTests \
    && mkdir app \
    && mv build/target/*.jar app/app.jar

COPY rhpam-springboot/rhpam-springboot.xml /app/


### EXECUTABLE IMAGE ###
FROM openjdk:8-jre-slim

COPY --from=builder-deps /root/.m2/repository /root/.m2/repository/
COPY --from=builder-app app app/

WORKDIR /app

EXPOSE 8090

CMD ["java", "-jar", "app.jar"]
