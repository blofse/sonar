#!/bin/bash

docker run -d --name sonar-alpine-centos7 --link sonar-postgres:pgsonar -p 9000:9000 -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD='(abc123)' -e SONARQUBE_JDBC_URL=jdbc:postgresql://pgsonar:5432/sonar sonar-alpine-centos7