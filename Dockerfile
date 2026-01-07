# ===== ETAPA 1: BUILD =====
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# 1. Copiamos todo el contenido
COPY . .

# 2. Listamos archivos para el log (esto nos ayudará a ver qué hay si falla)
RUN ls -R

# 3. Entramos directamente a la carpeta user-api y ejecutamos Maven
# Usamos 'mvn' directamente ya que la imagen base lo trae
RUN cd user-api && mvn package -DskipTests

# ===== ETAPA 2: RUN =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# 4. Copiamos el resultado desde la carpeta correcta
COPY --from=build /app/user-api/target/quarkus-app/ /app/

EXPOSE 8080
CMD ["java", "-jar", "quarkus-run.jar"]