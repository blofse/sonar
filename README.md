# sonar
A Docker container for Sonar, running apline but working for CentOS7 (also allows for restarting)
This fixes the inability to restart the sonar image but also sorts the permissions out (generally for CentOS, untested on other distros and may still work).
The intent is to use this image as a restartable service and run your sonar server.

Any feedback let me know - its all welcome!

This is based heavily from [this git hub repo](https://github.com/SonarSource/docker-sonarqube/blob/df10e8c9d58d09653100d96d823d8f96e08705cb/6.3-alpine/Dockerfile), however with some good additions.

# Pre-req

Before running this docker image, please [clone / download the repo](https://github.com/blofse/sonar, including the script files.

# How to use this image
## Initialise

Run the following command, replacing *** with your desired db password:
```
./initial_start '***'
```
This will setup two containers: 
* sonar-postgres - a container to store your sonar db data
* sonar - the container containing the sonar server

## (optional) setting up as a service

Once initialised and perhaps migrated, the docker container can then be run as a service. 
Included in the repo is the service for centos 7 based os's and to install run:
```
./copy_install_and_start_as_service.sh
```

