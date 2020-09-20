# vskurikhin/aarch64-jenkins
Docker image based on the [official jenkins docker image](https://github.com/jenkinsci/docker) for architecture aarch64.

# Configuration of the image
This image uses **openjdk:11-slim-buster** from the [OpenJDK is an open-source implementation of the Java Platform, Standard Edition](https://hub.docker.com/_/openjdk)

# Using

To use this container simply pull it from the docker repository:

```docker pull vskurikhin/aarch64-jenkins```

followed by

```docker run -p 8080:8080 -p 50000:50000 vskurikhin/aarch64-jenkins```
