#!/bin/bash

echo Stopping/removing services
systemctl stop docker-sonar-postgres
systemctl stop docker-sonar

systemctl disable docker-sonar-postgres
systemctl disable docker-sonar-jira

if [ -f /etc/systemd/system/docker-sonar.service ]; then
  rm -fr /etc/systemd/system/docker-sonar.service
fi
if [ -f /etc/systemd/system/docker-sonar-postgres.service ]; then
  rm -fr /etc/systemd/system/docker-sonar-postgres.service
fi

systemctl daemon-reload

echo Kill/remove docker images
docker stop sonar-postgres || true && docker rm sonar-postgres || true
docker stop sonar || true && docker rm sonar || true

echo Removing volumes
docker volume rm sonar-postgres-data || true
#docker volume rm atlassian-jira-home || true

echo Removing networks
docker network rm sonar-network || true

echo Removing docker image
#docker rmi sonar

echo Done!
