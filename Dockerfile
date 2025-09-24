FROM maven:3.9.5-openjdk-17 AS build

WORKDIR /app

# Copier les fichiers de configuration
COPY pom.xml .
COPY src ./src

# Builder l'application
RUN mvn clean package -DskipTests

FROM openjdk:17-jdk-slim

WORKDIR /app

# Copier avec pattern générique (évite les erreurs de nom)
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Ajouter des paramètres JVM pour optimisation
ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar"]
