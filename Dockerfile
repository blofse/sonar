FROM openjdk:8-alpine

ENV SONAR_VERSION=6.3 \
    SONARQUBE_HOME=/opt/sonarqube \
    # Database configuration
    # Defaults to using H2
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL= \
    SONAR_DOWNLOAD_URL=https://sonarsource.bintray.com/Distribution \
    SONAR_JAVA_PLUGIN_VERSION=4.6.0.8784 \
    SONAR_GITHUB_PLUGIN_VERSION=1.4.0.699 \
    SONAR_WEB_PLUGIN=2.5.0.476


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
    && wget -O sonarqube.zip --no-verbose ${SONAR_DOWNLOAD_URL}/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && wget -O sonarqube.zip.asc --no-verbose ${SONAR_DOWNLOAD_URL}/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/* \
    && mkdir -p /opt/sonarqube/extensions/plugins/ \
    && cd /opt/sonarqube/extensions/plugins/ \
    && wget -O sonar-java-plugin-${SONAR_JAVA_PLUGIN_VERSION}.jar --no-verbose ${SONAR_DOWNLOAD_URL}/sonar-java-plugin/sonar-java-plugin-${SONAR_JAVA_PLUGIN_VERSION}.jar \
    && wget -O sonar-web-plugin-${SONAR_WEB_PLUGIN}.jar --no-verbose ${SONAR_DOWNLOAD_URL}/sonar-web-plugin/sonar-web-plugin-${SONAR_WEB_PLUGIN}.jar \
    && wget -O sonar-scm-git-plugin-${SONAR_GITHUB_PLUGIN_VERSION}.jar --no-verbose ${SONAR_DOWNLOAD_URL}/sonar-github-plugin/sonar-github-plugin-${SONAR_GITHUB_PLUGIN_VERSION}.jar

# Add sonar user and setup permissions
RUN adduser -D -u 1000 sonar
RUN chown -R sonar "$SONARQUBE_HOME"
RUN chmod -R 755 "$SONARQUBE_HOME"

# Create the volumes and mount
VOLUME ["$SONARQUBE_HOME/data", "$SONARQUBE_HOME/extensions", "$SONARQUBE_HOME/conf", "$SONARQUBE_HOME/temp"]

# Setup the working dir and run file
WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
RUN chown sonar "$SONARQUBE_HOME/bin/run.sh"
RUN chmod +x "$SONARQUBE_HOME/bin/run.sh"

USER    sonar
ENTRYPOINT ["./bin/run.sh"]
