# sonar-alpine-centos7
A Docker container for Sonar, running apline but working for CentOS7 (also allows for restarting)
This fixes the inability to restart the sonar image but also sorts the permissions out (generally for CentOS, untested on other distros and may still work).
The intent is to use this image as a restartable service and run your sonar server.

Any feedback let me know - its all welcome!

This is based heavily from [this git hub repo](https://github.com/SonarSource/docker-sonarqube/blob/df10e8c9d58d09653100d96d823d8f96e08705cb/6.3-alpine/Dockerfile), however with some good additions.

# Pre-reqs
Sonar postgres must be setup prior to running this. To do so perform the following command, replacing *** with your own password:
```
docker run --name sonar-postgres -e POSTGRES_USER=sonar -e POSTGRES_PASSWORD='***' -d postgres
```

# How to use this image
Run the following command, replacing *** with the same password as the pre-reqs section:
```
docker run -d --name sonar-alpine-centos7 --link sonar-postgres:pgsonar -p 9000:9000 -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD='***' -e SONARQUBE_JDBC_URL=jdbc:postgresql://pgsonar:5432/sonar sonar-alpine-centos7
```

# Running as a service
An example service file is provided as part of the repo to run from CentOS 7 + systemd
