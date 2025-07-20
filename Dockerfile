# ---------- Build Stage ----------
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build

WORKDIR /app

COPY java-app/pom.xml .
COPY java-app/src ./src

RUN mvn clean package -DskipTests

# ---------- Runtime Stage ----------
FROM eclipse-temurin:21-jdk-alpine

VOLUME /tmp

COPY --from=build /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]
