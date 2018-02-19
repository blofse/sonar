#!/bin/sh

echo Stopping existing container
docker stop sonar
docker stop sonar-postgres

echo Copying and running service
yes | cp docker-sonar-postgres.service /etc/systemd/system/.
yes | cp docker-sonar.service /etc/systemd/system/.
systemctl daemon-reload

systemctl start docker-sonar-postgres
systemctl start docker-sonar
echo Done!
