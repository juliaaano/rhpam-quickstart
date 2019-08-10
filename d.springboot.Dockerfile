### DEPENDENCIES BUILDER IMAGE ###
FROM maven:3-jdk-8-slim as builder-deps

COPY rhdm-dependencies/pom.xml /build/rhdm-dependencies/
RUN mvn --file build/rhdm-dependencies/pom.xml --batch-mode install

COPY rhdm-event-listener/pom.xml /build/rhdm-event-listener/
RUN mvn --file build/rhdm-event-listener/pom.xml --batch-mode dependency:go-offline install -DskipTests

COPY rhdm-kjar/pom.xml /build/rhdm-kjar/
RUN mvn --file build/rhdm-kjar/pom.xml --batch-mode dependency:go-offline install -DskipTests

COPY rhdm-event-listener/src /build/rhdm-event-listener/src/
RUN mvn --file build/rhdm-event-listener/pom.xml --batch-mode --offline install -DskipTests

COPY rhdm-kjar/src /build/rhdm-kjar/src/
RUN mvn --file build/rhdm-kjar/pom.xml --batch-mode --offline install -DskipTests


### APP BUILDER IMAGE ###
FROM maven:3-jdk-8-slim as builder-app

COPY rhdm-springboot/pom.xml /build/

RUN mvn --file build/pom.xml --batch-mode dependency:go-offline

COPY rhdm-springboot/src /build/src/

RUN mvn --file build/pom.xml --batch-mode --offline package -DskipTests \
    && mkdir app \
    && mv build/target/*.jar app/app.jar

COPY rhdm-springboot/rhdm-springboot.xml /app/


### EXECUTABLE IMAGE ###
FROM openjdk:8-jre-slim

COPY --from=builder-deps /root/.m2/repository /root/.m2/repository/
COPY --from=builder-app app app/

WORKDIR /app

EXPOSE 8090

CMD ["java", "-jar", "app.jar"]
