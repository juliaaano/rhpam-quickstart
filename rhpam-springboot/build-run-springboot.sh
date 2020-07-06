#!/bin/bash

set -euxo pipefail

mvn --file ../rhpam-dependencies/pom.xml clean install
mvn --file ../rhpam-event-listener/pom.xml clean install
mvn --file ../rhpam-kjar/pom.xml clean install
mvn spring-boot:run
