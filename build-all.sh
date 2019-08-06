#!/bin/bash

set -euxo pipefail

mvn --file rhdm-dependencies/pom.xml clean install
mvn --file rhdm-event-listener/pom.xml clean install
mvn --file rhdm-quickstart/pom.xml clean install
