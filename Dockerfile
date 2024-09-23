FROM sonarsource/sonar-scanner-cli AS sonarqube
WORKDIR /usr/src
COPY . /usr/src/
RUN sonar-scanner \
  -Dsonar.projectKey=my-project \
  -Dsonar.projectBaseDir=/usr/src \
  -Dsonar.host.url=https://172.17.0.2:9000 \
  -Dsonar.exclusions=**/*.java \
  -Dsonar.token=sqp_d3eec411d6061cc9bf6b7c622fd96f31efd8d55d

FROM maven:3.8.7-openjdk-18 AS build
WORKDIR /app
COPY . /app
RUN chmod +x ./mvnw
RUN ./mvnw package


FROM openjdk:18-alpine
WORKDIR /code
COPY --from=build /app/target/*.jar /code/
CMD ["sh", "-c", "java -jar /code/*.jar"]

