# ---------- Builder ----------
FROM amazoncorretto:25 AS builder

WORKDIR /usr/src/app

# Install tools required by Gradle wrapper downloads/extraction
# (Render builders are clean; do not assume these exist.)
RUN yum -y update \
 && yum -y install unzip tar gzip findutils \
 && yum -y clean all \
 && rm -rf /var/cache/yum

# Copy Gradle wrapper and build scripts first (better caching)
COPY gradlew ./
COPY gradle/wrapper ./gradle/wrapper
COPY settings.gradle* build.gradle* gradle.properties* ./

# Ensure wrapper is executable
RUN chmod +x ./gradlew

# Copy source last
COPY src ./src

# Build the Spring Boot fat jar
RUN ./gradlew bootJar --no-daemon


# ---------- Runtime ----------
FROM amazoncorretto:25

WORKDIR /usr/src/app

# Render will provide PORT; default locally to 8080.
ENV PORT=8080

# Copy the built jar from the builder stage
COPY --from=builder /usr/src/app/build/libs/*.jar ./app.jar

# Document the port (Render doesn’t rely on EXPOSE, but it’s fine to keep)
EXPOSE 8080

# Bind Spring Boot to Render's $PORT
ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT} -jar /usr/src/app/app.jar"]
