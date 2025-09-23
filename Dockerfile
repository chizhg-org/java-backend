# Stage 1: Build the application
# Use a specific Maven image that includes JDK 21
FROM maven:3.9.6-eclipse-temurin-21-jammy AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project file (pom.xml)
COPY pom.xml .

# Download dependencies first to leverage Docker layer caching
# This way, if only source code changes, we don't re-download dependencies
RUN mvn dependency:go-offline

# Copy the rest of your application's source code
COPY src ./src

# Build the application and create the executable JAR
# We skip tests here, assuming they've run in a prior CI/test step
# The packaged JAR will be in /app/target/
RUN mvn package -DskipTests

# ----------------------------------------------------------------
# Stage 2: Create the final runtime image
# Use a minimal Java Runtime Environment (JRE) for a smaller, more secure image
FROM eclipse-temurin:21-jre-jammy

# Set the working directory
WORKDIR /app

# --- Security Best Practice: Run as non-root user ---
# Create a dedicated, non-privileged user and group
RUN groupadd --system appuser && useradd --system -g appuser appuser

# Copy the built JAR from the 'build' stage
# This wildcard copy will find the executable JAR in the target directory
# (e.g., my-app-0.0.1-SNAPSHOT.jar) and rename it to app.jar
COPY --from=build /app/target/*.jar app.jar

# Set ownership of the app files to the non-root user
RUN chown -R appuser:appuser /app

# Switch to the non-root user
USER appuser

# Expose the default Spring Boot port (Cloud Run will pick this up)
EXPOSE 8080

# The command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
