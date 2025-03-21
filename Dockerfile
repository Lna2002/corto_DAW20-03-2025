# Etapa 1: Compilar la aplicación con Maven Wrapper
FROM eclipse-temurin:17-jdk-alpine AS build

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar archivos necesarios para compilar (Maven wrapper, configuración y código)
COPY .mvn .mvn
COPY mvnw mvnw
COPY pom.xml pom.xml

# Descargar dependencias para evitar errores al copiar src después
RUN ./mvnw dependency:go-offline -B

# Copiar el resto del código fuente
COPY src src

# Compilar el proyecto (sin ejecutar pruebas)
RUN ./mvnw package -DskipTests

# Etapa 2: Ejecutar la aplicación compilada
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copiar el JAR generado desde la etapa de compilación
COPY --from=build /app/target/*.jar app.jar

# Exponer el puerto 8080 (ya mapeado en docker-compose.yml)
EXPOSE 8080

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "app.jar"]
