# ==========================================
# Stage 1: Build
# ==========================================
FROM maven:3.9.6-eclipse-temurin-21-alpine AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: Runtime
# ==========================================
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Run as non-root for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy the built JAR 
COPY --from=builder --chown=spring:spring /app/target/*.jar app.jar

EXPOSE 8080

# Simple, reliable execution
ENTRYPOINT ["java", "-jar", "app.jar"]