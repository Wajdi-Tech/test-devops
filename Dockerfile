# Étape 1 : Build avec Maven intégré (pas besoin d'installer Maven)
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /app

# Copie d'abord les fichiers Maven pour profiter du cache
COPY pom.xml .
COPY src ./src

# Build + création du fat JAR exécutable (spring-boot:repackage est automatique avec le plugin)
RUN mvn -B -DskipTests clean verify

# Étape 2 : Image finale ultra-légère
FROM eclipse-temurin:17-jre-alpine
WORKDIR /opt/app

# Copie le JAR exécutable (le nom exact est généré par Spring Boot)
COPY --from=build /app/target/test-devops-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8888

# Lancement direct du JAR exécutable
ENTRYPOINT ["java", "-jar", "app.jar"]
