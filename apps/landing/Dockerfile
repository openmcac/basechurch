FROM openjdk:8 

# Install maven
RUN apt-get update
RUN apt-get install -y maven

RUN mkdir /app
WORKDIR /app

# Prepare by downloading dependencies
ADD pom.xml /app/pom.xml
RUN ["mvn", "dependency:resolve"]

ADD src /app/src
RUN ["mvn", "verify", "-DskipTests"]
RUN ["mvn", "package", "-DskipTests"]
