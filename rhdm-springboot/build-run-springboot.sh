#!/bin/bash

set -euxo pipefail

mvn --file ../rhdm-dependencies/pom.xml clean install
mvn --file ../rhdm-event-listener/pom.xml clean install
mvn --file ../rhdm-kjar/pom.xml clean install
mvn spring-boot:run
