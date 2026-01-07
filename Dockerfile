# ===== ETAPA 1: BUILD =====
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Copiamos todo el contenido
COPY . .

# Buscamos el archivo mvnw y el pom.xml en todo el repositorio y entramos ahí
# Este comando busca la carpeta que contiene el pom.xml y nos mueve ahí
RUN export PROJECT_DIR=$(find . -name "pom.xml" -printf '%h' -quit) && \
    cd $PROJECT_DIR && \
    chmod +x ./mvnw && \
    ./mvnw package -DskipTests

# ===== ETAPA 2: RUN =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copiamos el resultado buscando donde sea que se haya generado el target
COPY --from=build /app/**/target/quarkus-app/ /app/

EXPOSE 8080
CMD ["java", "-jar", "quarkus-run.jar"]