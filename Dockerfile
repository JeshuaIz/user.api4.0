# ===== ETAPA 1: BUILD =====
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# 1. Copiamos TODO
COPY . .

# 2. Entramos a la carpeta donde está el proyecto y compilamos desde ahí
# Usamos el flag -f para decirle a Maven exactamente dónde está el pom.xml
RUN mvn -f user-api/pom.xml package -DskipTests

# ===== ETAPA 2: RUN =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# 3. Copiamos el resultado (estará dentro de la subcarpeta target de user-api)
COPY --from=build /app/user-api/target/quarkus-app/ /app/

EXPOSE 8080

CMD ["java", "-jar", "quarkus-run.jar"]