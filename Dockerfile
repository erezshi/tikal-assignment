FROM tomcat:9.0-jre8-alpine
COPY target/helloworld*.war $CATALINA_HOME/webapps/helloworld.war


