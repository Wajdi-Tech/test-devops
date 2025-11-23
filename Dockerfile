FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests clean package

# Cette ligne est cruciale : repackage pour créer le "fat JAR" exécutable
RUN mvn -B spring-boot:repackage

FROM eclipse-temurin:17-jre-alpine
WORKDIR /opt/app
COPY --from=build /app/target/test-devops-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8888
ENTRYPOINT ["java", "-jar", "app.jar"]
