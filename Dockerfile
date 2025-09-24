# Étape de build
FROM maven:3.9.5-openjdk-17 AS build

WORKDIR /app

# Copier le pom.xml d'abord (pour optimiser le cache Docker)
COPY pom.xml .

# Télécharger les dépendances (optimisation du cache)
RUN mvn dependency:go-offline -B

# Copier les sources
COPY src ./src

# Builder l'application
RUN mvn clean package -DskipTests

# Étape d'exécution
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copier le JAR généré (nom basé sur votre pom.xml)
COPY --from=build /app/target/pattern-manager-0.0.1-SNAPSHOT.jar app.jar

# Exposer le port
EXPOSE 8080

# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.jar"]
