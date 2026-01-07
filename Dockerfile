# ===== ETAPA 1: BUILD =====
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# 1. Copiamos TODO lo que subiste
COPY . .

# 2. TRUCO MAESTRO: 
# Si el pom.xml está en una subcarpeta, movemos todo su contenido a la raíz /app
RUN if [ ! -f "pom.xml" ]; then \
    SUBDIR=$(find . -name "pom.xml" -printf '%h' -quit); \
    echo "Moviendo archivos desde $SUBDIR a la raíz"; \
    cp -r $SUBDIR/. .; \
    fi

# 3. Verificamos qué hay ahora (para estar seguros)
RUN ls -la

# 4. Compilamos
RUN mvn package -DskipTests

# ===== ETAPA 2: RUN =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# Buscamos el resultado donde sea que haya quedado
COPY --from=build /app/target/quarkus-app/ /app/

EXPOSE 8080
CMD ["java", "-jar", "quarkus-run.jar"]