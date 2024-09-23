FROM newtmitch/sonar-scanner AS sonarqube
WORKDIR /usr/src
COPY . /usr/src/
RUN sonar-scanner \
  -Dsonar.projectKey=petclinic-new \
  -Dsonar.projectBaseDir=/usr/src \
  -Dsonar.host.url=http://127.0.0.1:9000 \
  -Dsonar.token=sqp_8f4e34813439afb7dc07d2961fc7224b41c2b79b

FROM maven:3.8.7-openjdk-18 AS build
WORKDIR /app
COPY . /app
RUN chmod +x ./mvnw
RUN ./mvnw package

#FROM openjdk:8-jre
#FROM openjdk:17-alpine

FROM openjdk:18-alpine
WORKDIR /code
COPY --from=build /app/target/*.jar /code/
CMD ["sh", "-c", "java -jar /code/*.jar"]

