FROM openjdk:8-alpine

ENV SONAR_VERSION=6.3 \
    SONARQUBE_HOME=/opt/sonarqube \
    # Database configuration
    # Defaults to using H2
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=


# Http port
EXPOSE 9000

RUN set -x \
    && apk add --no-cache gnupg unzip \
    && apk add --no-cache libressl wget \

    # pub   2048R/D26468DE 2015-05-25
    #       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
    # uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
    # sub   2048R/06855C1D 2015-05-25
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \

    && mkdir /opt \
    && cd /opt \
    && wget -O sonarqube.zip --no-verbose https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && wget -O sonarqube.zip.asc --no-verbose https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

RUN adduser -D -u 1000 sonar
RUN chown -R sonar "$SONARQUBE_HOME"
RUN chmod -R 755 "$SONARQUBE_HOME"

VOLUME ["$SONARQUBE_HOME/data", "$SONARQUBE_HOME/extensions", "$SONARQUBE_HOME/conf", "$SONARQUBE_HOME/temp"]

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
RUN chown sonar "$SONARQUBE_HOME/bin/run.sh"
RUN chmod +x "$SONARQUBE_HOME/bin/run.sh"

USER    sonar
ENTRYPOINT ["./bin/run.sh"]
