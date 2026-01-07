# ===== ETAPA 1: BUILD =====
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# 1. Copiamos todos los archivos de la raíz (pom.xml, src, etc.)
COPY . .

# 2. Ejecutamos el build directamente (ya que el pom.xml está aquí mismo)
RUN mvn package -DskipTests

# ===== ETAPA 2: RUN =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# 3. Copiamos el resultado de la carpeta target
COPY --from=build /app/target/quarkus-app/ /app/

EXPOSE 8080

# Comando para iniciar Quarkus
CMD ["java", "-jar", "quarkus-run.jar"]