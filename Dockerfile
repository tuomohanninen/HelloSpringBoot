FROM amazoncorretto:25 AS builder

WORKDIR /usr/src/app

# Copy Gradle wrapper and build files
COPY gradlew .
COPY gradle gradle
COPY build.gradle* .
COPY settings.gradle* .

# Copy source code
COPY src src

# Make gradlew executable and build the application
RUN chmod +x gradlew && ./gradlew bootJar --no-daemon

FROM amazoncorretto:25

WORKDIR /usr/src/app

EXPOSE 8080

# Copy the built jar from the builder stage
COPY --from=builder /usr/src/app/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/usr/src/app/app.jar"]
