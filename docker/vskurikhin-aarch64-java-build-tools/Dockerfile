FROM ubuntu:20.04
LABEL name="Java Build Tools" \
      maintainer="Victor N. Skurikhin <vskurikhin@gmail.com>" \
      license="Apache-2.0" \
      version="latest" \
      summary="Convenient Docker image to build Java applications." \
      description="Convenient Docker image to build Java applications."

COPY entry_point.sh /opt/bin/entry_point.sh
COPY functions.sh /opt/bin/functions.sh

#=====================
# Maven / Ant / Gradle
#=====================
ENV MAVEN_VERSION 3.6.3
ENV MAVEN_HOME /usr/share/maven
ENV ANT_VERSION 1.10.9
ENV ANT_HOME /usr/share/ant
ENV GRADLE_VERSION 6.5.1

#================================================
# Customize sources for apt-get
#================================================

RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install software-properties-common \
  && add-apt-repository -y ppa:git-core/ppa \
  && apt-get -qqy --no-install-recommends install \
    iproute2 \
    openssh-client ssh-askpass\
    ca-certificates \
    gpg gpg-agent \
    openjdk-8-jdk \
    tar zip unzip \
    wget curl \
    git \
    less vim-tiny tree \
    jq \
  && apt-get clean \
  && sed -i 's/securerandom\.source=file:\/dev\/random/securerandom\.source=file:\/dev\/urandom/' ./usr/lib/jvm/java-8-openjdk-arm64/jre/lib/security/java.security \
  && curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
  && curl -fsSL https://www.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-ant-$ANT_VERSION /usr/share/ant \
  && ln -s /usr/share/ant/bin/ant /usr/bin/ant \
  && wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp \
  && unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip \
  && ln -s /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle \
  && rm /tmp/gradle-${GRADLE_VERSION}-bin.zip \
  && chmod +x /opt/bin/entry_point.sh \
  && chmod +x /opt/bin/functions.sh \
  && useradd jenkins --shell /bin/bash --create-home \
  && usermod -a -G sudo jenkins \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'jenkins:secret' | chpasswd \
  && mkdir -p /home/jenkins/.local/bin/ \
  && chown -R jenkins:jenkins /home/jenkins/.local \
  && curl https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/arm64/kubectl -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/* /var/tmp/*

USER jenkins

# for dev purpose
# USER root

ENTRYPOINT ["/opt/bin/entry_point.sh"]

EXPOSE 4444
