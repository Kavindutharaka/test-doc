# Use a base image with Java and Tomcat installed
FROM tomcat:9.0-jdk11

RUN groupadd -g 10014 choreo && \
    useradd --no-create-home --uid 10014 --gid choreo choreouser

# RUN chown -R choreouser:choreo /usr/local/tomcat
RUN chown -R 10014:choreo /usr/local/tomcat


USER 10014

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# RUN chown -R choreouser:choreo /usr/local/tomcat


# Copy the .war file into the webapps directory
COPY target/oidc-sample-app.war $CATALINA_HOME/webapps/oidc-sample-app.war

# Expose the port on which Tomcat will run
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
