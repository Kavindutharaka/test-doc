# Use a base image with Java and Tomcat installed
FROM tomcat:9.0.91-jdk17

# Create a group and user if they don't already exist
RUN groupadd --gid 10015 choreo || true && \
    useradd --uid 10015 --gid choreo --no-create-home --shell /bin/sh choreouser || true

# Switch to root to install unzip and handle the WAR file
USER root

# Install unzip
RUN apt-get update && apt-get install -y unzip

# Copy the WAR file into the container
COPY target/oidc-sample-app.war /oidc-sample-app.war

# Unzip the WAR file into Tomcat webapps directory
RUN unzip /oidc-sample-app.war -d /usr/local/tomcat/webapps/oidc-sample-app && \
    rm /oidc-sample-app.war

# Change ownership of Tomcat directory to the non-root user
RUN chown -R 10015:choreo /usr/local/tomcat

# Switch to the non-root user
USER 10015

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Copy logging properties
COPY logging.properties $CATALINA_HOME/conf/logging.properties

# Expose the port on which Tomcat will run
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
