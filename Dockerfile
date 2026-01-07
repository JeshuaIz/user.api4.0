# ===== ETAPA 1: BUILD =====
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# 1. Copiamos todo el contenido del repositorio
COPY . .

# 2. Damos permiso al mvnw que está en la raíz (/app)
RUN chmod +x ./mvnw

# 3. Entramos a la subcarpeta para compilar el proyecto
WORKDIR /app/user-api

# 4. Ejecutamos el wrapper llamándolo desde la carpeta de arriba (..)
RUN ../mvnw package -DskipTests

# ===== ETAPA 2: RUN =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# 5. Copiamos el resultado (está dentro de user-api/target)
COPY --from=build /app/user-api/target/quarkus-app/ /app/

EXPOSE 8080
CMD ["java", "-jar", "quarkus-run.jar"]