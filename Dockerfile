FROM amazoncorretto:25

# Use /usr/src/app as working directory
WORKDIR /usr/src/app

# Expose the application's port
EXPOSE 8080

# Copy the executable Spring Boot jar (built by Gradle) into the image
# Use a wildcard so you don't need to update the exact versioned filename each build
COPY build/libs/*.jar app.jar

# Make sure the jar is executable and run it
RUN chmod a+x /usr/src/app/app.jar

ENTRYPOINT ["java", "-jar", "/usr/src/app/app.jar"]
