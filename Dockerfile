# ===== ETAPA 1: BUILD =====
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# 1. Copiamos TODO lo que hay en el repo a la imagen
COPY . .

# 2. Entramos a la carpeta donde realmente está el pom.xml
# Si tu proyecto está en 'user-api', debemos trabajar ahí dentro
WORKDIR /app/user-api

# 3. Damos permisos y ejecutamos el wrapper
RUN chmod +x mvnw
RUN ./mvnw package -DskipTests

# ===== ETAPA 2: RUN =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# 4. Ajustamos la ruta de origen para copiar el resultado del build
# Como el build se hizo en /app/user-api, el target está ahí
COPY --from=build /app/user-api/target/quarkus-app/ /app/

EXPOSE 8080
CMD ["java", "-jar", "quarkus-run.jar"]
