FROM --platform=linux/amd64 eclipse-temurin:8-jdk-alpine
ARG artifact=target/aioofbot-0.0.1-SNAPSHOT.jar
COPY ${artifact} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

