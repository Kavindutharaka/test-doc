# FROM tomcat:9.0.91-jdk17

# RUN groupadd -g 10014 choreo && \
#     useradd --no-create-home --uid 10014 --gid choreo choreouser

# RUN chown -R 10014:choreo /usr/local/tomcat


# USER 10014

# ENV CATALINA_HOME /usr/local/tomcat
# ENV PATH $CATALINA_HOME/bin:$PATH

# COPY target/oidc-sample-app.war $CATALINA_HOME/webapps/oidc-sample-app.war

# EXPOSE 8080

# CMD ["catalina.sh", "run"]

FROM tomcat:9.0.91-jdk17

# Create a user and group for Choreo
RUN groupadd -g 10014 choreo && \
    useradd --no-create-home --uid 10014 --gid choreo choreouser

# Set permissions for Tomcat
RUN chown -R 10014:choreo /usr/local/tomcat

# Switch to non-root user
USER 10014

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Copy your WAR file to Tomcat's webapps directory
COPY target/oidc-sample-app.war /tmp/oidc-sample-app.war

# Copy the Logback configuration file to a writable directory
COPY src/main/resources/logback.xml /tmp/logback.xml

# Set environment variable to use the custom Logback configuration
ENV JAVA_OPTS="-Dlogback.configurationFile=/tmp/logback.xml"

# Expose port and start Tomcat
EXPOSE 8080
CMD ["catalina.sh", "run"]
