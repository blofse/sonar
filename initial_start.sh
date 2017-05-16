#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Expecting one argument'
    exit 0
fi

docker run --name sonar-postgres -e POSTGRES_USER=sonar -e POSTGRES_PASSWORD="$1" -d postgres
docker run -d --name sonar --link sonar-postgres:pgsonar -p 9000:9000 -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD="$1" -e SONARQUBE_JDBC_URL=jdbc:postgresql://pgsonar:5432/sonar sonar

