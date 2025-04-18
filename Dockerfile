FROM openjdk:21-jdk-slim
COPY target/mon-app.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
EXPOSE 8080
