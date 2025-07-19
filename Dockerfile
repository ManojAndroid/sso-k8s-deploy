# ---------- Build Stage ----------
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build

WORKDIR /app

COPY java-app/pom.xml .
COPY java-app/src ./src

RUN mvn clean package -DskipTests

# ---------- Runtime Stage ----------
FROM openjdk:21-alpine

VOLUME /tmp

COPY --from=build /app/target/*.jar app.jar

ENV SERVER_PORT=8080 \
    SPRING_PROFILES_ACTIVE=prod \
    DB_URL=jdbc:mysql://mysql:3306/sso_db \
    DB_USERNAME=root \
    DB_PASSWORD=root

ENTRYPOINT ["java", "-jar", "/app.jar"]
