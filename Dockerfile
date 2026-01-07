# Etapa 1: build
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn package -DskipTests

# Etapa 2: run
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/quarkus-app /app/quarkus-app
EXPOSE 8080
CMD ["java", "-jar", "quarkus-app/quarkus-run.jar"]
