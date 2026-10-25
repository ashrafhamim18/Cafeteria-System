FROM tomcat:11.0-jdk21-temurin

WORKDIR /opt/cafeteria

COPY src/main/java /opt/cafeteria/src/main/java
COPY src/main/webapp /opt/cafeteria/webapp

# Compile the application against Tomcat's Jakarta Servlet API.
RUN mkdir -p /opt/cafeteria/classes \
    && javac --release 21 \
       -cp /usr/local/tomcat/lib/servlet-api.jar:/opt/cafeteria/webapp/WEB-INF/lib/mysql-connector-j-9.3.0.jar \
       -d /opt/cafeteria/classes \
       $(find /opt/cafeteria/src/main/java -name '*.java') \
    && mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    && cp -R /opt/cafeteria/webapp/. /usr/local/tomcat/webapps/ROOT/ \
    && cp -R /opt/cafeteria/classes/. /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ \
    && rm -f /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/mysql-connector-java-5.1.47-bin.jar

ENV CATALINA_OPTS="-Dfile.encoding=UTF-8"
EXPOSE 8080
CMD ["catalina.sh", "run"]
