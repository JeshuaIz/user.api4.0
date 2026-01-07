# ===== ETAPA 1: BUILD =====
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# 1. Copiamos todo el contenido del repositorio
COPY . .

# 2. Buscamos dónde está el pom.xml y compilamos usando 'mvn' directamente
RUN export PROJECT_DIR=$(find . -name "pom.xml" -printf '%h' -quit) && \
    cd $PROJECT_DIR && \
    mvn package -DskipTests

# ===== ETAPA 2: RUN =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# 3. Copiamos el resultado buscando el target generado
COPY --from=build /app/**/target/quarkus-app/ /app/

EXPOSE 8080
CMD ["java", "-jar", "quarkus-run.jar"]