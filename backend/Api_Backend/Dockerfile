FROM eclipse-temurin:17-jdk-alpine 
VOLUME /tmp 
COPY target/rest-service-complete-0.0.1-SNAPSHOT.jar target/app.jar 
ENTRYPOINT ["java","-jar","/target/app.jar"]
