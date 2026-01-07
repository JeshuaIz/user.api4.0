# ===== ETAPA 1: BUILD =====
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# 1. Copiamos todo el contenido del repositorio
COPY . .

# 2. Buscamos el pom.xml y compilamos donde sea que esté
RUN mvn package -f $(find . -name "pom.xml" -print -quit) -DskipTests

# ===== ETAPA 2: RUN =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# 3. Copiamos el resultado buscando el archivo quarkus-run.jar
# Esto busca en cualquier subcarpeta target que se haya creado
COPY --from=build /app/**/target/quarkus-app/ /app/

EXPOSE 8080

# Usamos la ruta donde Quarkus deja el ejecutable
CMD ["java", "-jar", "/app/quarkus-run.jar"]