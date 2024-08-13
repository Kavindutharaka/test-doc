FROM tomcat:9.0.91-jdk17


RUN groupadd --gid 10015 choreo || true && \
    useradd --uid 10015 --gid choreo --no-create-home --shell /bin/sh choreouser || true

USER root

RUN apt-get update 
RUN apt-get install -y unzip

RUN chown -R 10015:choreo /usr/local/tomcat

USER 10015

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

COPY target/oidc-sample-app.war $CATALINA_HOME/webapps/oidc-sample-app.war
RUN ls -al $CATALINA_HOME/webapps/
# RUN file oidc-sample-app.war
RUN unzip $CATALINA_HOME/webapps/oidc-sample-app.war -d $CATALINA_HOME/webapps/oidc-sample-app && rm $CATALINA_HOME/webapps/oidc-sample-app.war

RUN ls -al $CATALINA_HOME/webapps/oidc-sample-app

COPY oidc-sample-app.properties $CATALINA_HOME/webapps/oidc-sample-app/WEB-INF/classes/

COPY logging.properties $CATALINA_HOME/conf/logging.properties

EXPOSE 8080

CMD ["catalina.sh", "run"]
