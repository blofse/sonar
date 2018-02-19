#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Expecting one argument'
    exit 0
fi

docker network create \
  --driver bridge \
  sonar-network

docker run \
  --name sonar-postgres \
  -e POSTGRES_USER=sonar \
  -e POSTGRES_PASSWORD="$1" \ 
  -v sonar-postgres-data:/var/lib/postgresql/data \
  --net sonar-network \
  -d \
  postgres

docker run \
  --name sonar \
  -p 9000:9000 \
  -e SONARQUBE_JDBC_USERNAME=sonar \
  -e SONARQUBE_JDBC_PASSWORD="$1" \
  -e SONARQUBE_JDBC_URL=jdbc:postgresql://sonar-postgres:5432/sonar \
  --net sonar-network
  -d \
  sonar

