# build the application with maven jdk-17
FROM public.ecr.aws/docker/library/maven:3-amazoncorretto-17 AS build
WORKDIR /project
ADD pom.xml /project
COPY . .
# Sonar Setup
ARG SONARQUBE_TOKEN
ARG SONARQUBE_URL
ARG SONARQUBE_ENV
RUN mvn clean package
# La ejecucion de sonar tienen que ocurrir luego del package
RUN if [ $SONARQUBE_ENV = "prod" ] ; then mvn sonar:sonar -Dsonar.host.url=$SONARQUBE_URL -Dsonar.login=$SONARQUBE_TOKEN; else echo "$SONARQUBE_ENV no envia a sonar"; fi
# end Sonar Setup

# Add the jar to the final docker image
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17
COPY --from=build /project/target/demo-0.0.1.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]