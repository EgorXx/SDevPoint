FROM eclipse-temurin:25-jdk-alpine AS builder

WORKDIR /app
COPY gradlew gradlew.bat ./
COPY gradle/ gradle/
COPY build.gradle.kts settings.gradle.kts gradle.properties ./
RUN ./gradlew dependencies --no-daemon --stacktrace

COPY src/ src/
RUN ./gradlew bootJar --no-daemon --stacktrace

FROM eclipse-temurin:25-jre-alpine

RUN addgroup -S app && adduser -S app -G app
RUN mkdir -p /data/images && chown app:app /data/images

USER app
WORKDIR /app

COPY --from=builder /app/build/libs/sdevpoint-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-XX:+UseZGC", "-XX:MaxRAMPercentage=75", "-jar", "app.jar"]