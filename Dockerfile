# build the application with maven jdk-17
FROM public.ecr.aws/docker/library/maven:3-amazoncorretto-17 AS build
WORKDIR /project
ADD pom.xml /project
COPY . .
ARG SONARQUBE_TOKEN
ENV SONARQUBE_TOKEN=${SONARQUBE_TOKEN}
ARG SONARQUBE_URL
ENV SONARQUBE_URL=${SONARQUBE_URL}
ARG ENVIRONMENT
ENV ENVIRONMENT=${ENVIRONMENT}
# http://192.168.0.12:9000
# squ_9c39e10226fd4fdcc220eb310c76a92c8523b482
RUN mvn package
RUN if [ "$ENVIRONMENT" = "prod" ] ; then mvn sonar:sonar -Pcoverage -Dsonar.host.url=${SONARQUBE_URL} -Dsonar.login=${SONARQUBE_TOKEN}; else echo "$ENVIRONMENT no envia a sonar"; fi
ENV SONARQUBE_TOKEN=''
ENV SONARQUBE_URL=''

# Add the jar to the final docker image
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17
COPY --from=build /project/target/demo-0.0.1.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]