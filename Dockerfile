# ===== ETAPA 1: BUILD =====
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copiamos todo lo que hay en la raíz (incluyendo tu pom.xml y src)
COPY . .

# Ejecutamos la compilación
RUN mvn package -DskipTests

# ===== ETAPA 2: RUN =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# Quarkus genera el resultado en target/quarkus-app/
COPY --from=build /app/target/quarkus-app/ /app/

EXPOSE 8080

# Comando para arrancar la aplicación
CMD ["java", "-jar", "quarkus-run.jar"]