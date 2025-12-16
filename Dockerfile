#----------------------------------
# Stage 1
#----------------------------------

# Import docker image with maven installed
# FROM maven:3.8.3-openjdk-17 as builder 
# Import docker image with Maven and JDK 17 (from Eclipse Temurin)
FROM maven:3.8.3-eclipse-temurin-17 as builder
# Set working directory
WORKDIR /app

# Copy source code from local to container
COPY . /app

# Build application and skip test cases
RUN mvn clean install -DskipTests=true

#--------------------------------------
# Stage 2
#--------------------------------------

# Import small size java image
# FROM openjdk:17-alpine as deployer
# Use eclipse-temurin:17-jdk-alpine for runtime
FROM eclipse-temurin:17-jdk-alpine as deployer


# Copy build from stage 1 (builder)
COPY --from=builder /app/target/*.jar /app/target/bankapp.jar

# Expose application port 
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "/app/target/bankapp.jar"]
