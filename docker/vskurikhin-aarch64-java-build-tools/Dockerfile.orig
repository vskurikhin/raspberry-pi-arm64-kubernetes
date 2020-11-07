FROM ubuntu:20.04
LABEL name="Java Build Tools" \
      maintainer="Cloudbees CloudPlatform Security Members <cloud-platform-security-members@cloudbees.com>" \
      license="Apache-2.0" \
      version="latest" \
      summary="Convenient Docker image to build Java applications." \
      description="Convenient Docker image to build Java applications."


#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#################################################
# Inspired by
# https://github.com/SeleniumHQ/docker-selenium/blob/master/Base/Dockerfile
#################################################


#================================================
# Customize sources for apt-get
#================================================
RUN DISTRIB_CODENAME=$(cat /etc/*release* | grep DISTRIB_CODENAME | cut -f2 -d'=') \
    && echo "deb http://archive.ubuntu.com/ubuntu ${DISTRIB_CODENAME} main universe\n" > /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu ${DISTRIB_CODENAME}-updates main universe\n" >> /etc/apt/sources.list \
    && echo "deb http://security.ubuntu.com/ubuntu ${DISTRIB_CODENAME}-security main universe\n" >> /etc/apt/sources.list

RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install software-properties-common \
  && add-apt-repository -y ppa:git-core/ppa

#========================
# Miscellaneous packages
# iproute which is surprisingly not available in ubuntu:15.04 but is available in ubuntu:latest
# OpenJDK8
# rlwrap is for azure-cli
# groff is for aws-cli
# tree is convenient for troubleshooting builds
#========================
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    azure-cli \
    iproute2 \
    openssh-client ssh-askpass\
    ca-certificates \
    gpg gpg-agent \
    openjdk-8-jdk \
    tar zip unzip \
    wget curl \
    git \
    build-essential \
    less nano tree \
    jq \
    python3 python3-pip groff \
    rlwrap \
    rsync \
  && apt-get clean \
  && sed -i 's/securerandom\.source=file:\/dev\/random/securerandom\.source=file:\/dev\/urandom/' ./usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security

# Update pip after install
RUN pip3 install --upgrade pip setuptools

RUN pip3 install yq

#==========
# Maven
#==========
ENV MAVEN_VERSION 3.6.3

RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

#==========
# Ant
#==========

ENV ANT_VERSION 1.10.8

RUN curl -fsSL https://www.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-ant-$ANT_VERSION /usr/share/ant \
  && ln -s /usr/share/ant/bin/ant /usr/bin/ant

ENV ANT_HOME /usr/share/ant

#==========
# Gradle
#==========

ENV GRADLE_VERSION 6.5.1

RUN wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp \
  && unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip \
  && ln -s /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle \
  && rm /tmp/gradle-${GRADLE_VERSION}-bin.zip

#==========
# Selenium
#==========

ENV SELENIUM_MAJOR_VERSION 3.141
ENV SELENIUM_VERSION 3.141.59
RUN  mkdir -p /opt/selenium \
  && wget --no-verbose http://selenium-release.storage.googleapis.com/$SELENIUM_MAJOR_VERSION/selenium-server-standalone-$SELENIUM_VERSION.jar -O /opt/selenium/selenium-server-standalone.jar

RUN pip3 install -U selenium

# https://github.com/SeleniumHQ/docker-selenium/blob/master/StandaloneFirefox/Dockerfile

ENV SCREEN_WIDTH 1360
ENV SCREEN_HEIGHT 1020
ENV SCREEN_DEPTH 24
ENV DISPLAY :99.0

COPY entry_point.sh /opt/bin/entry_point.sh
COPY functions.sh /opt/bin/functions.sh
RUN chmod +x /opt/bin/entry_point.sh \
  && chmod +x /opt/bin/functions.sh

#========================================
# Add normal user with passwordless sudo
#========================================
RUN useradd jenkins --shell /bin/bash --create-home \
  && usermod -a -G sudo jenkins \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'jenkins:secret' | chpasswd

#=====
# XVFB
#=====
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    xvfb \
  && apt-get clean

#=========
# Firefox
#=========
ARG FIREFOX_VERSION=78.0.2esr

# don't install firefox with apt-get because there are some problems,
# install the binaries downloaded from mozilla
# see https://github.com/SeleniumHQ/docker-selenium/blob/3.0.1-fermium/NodeFirefox/Dockerfile#L13
# workaround "D-Bus library appears to be incorrectly set up; failed to read machine uuid"
# run "dbus-uuidgen > /var/lib/dbus/machine-id"

RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install firefox dbus \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
  && wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
  && apt-get -y purge firefox \
  && rm -rf /opt/firefox \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
  && ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox \
  && apt-get clean

RUN dbus-uuidgen > /var/lib/dbus/machine-id

#======================
# Firefox GECKO DRIVER
#======================

ARG GECKO_DRIVER_VERSION=v0.26.0
RUN wget -O - "https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VERSION/geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz" \
      | tar -xz -C /usr/bin

#====================================
# Cloud Foundry CLI
# https://github.com/cloudfoundry/cli
#====================================
RUN wget -O - "http://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -C /usr/local/bin -zxf -

#====================================
# AWS CLI
#====================================
RUN pip3 install awscli

# compatibility with CloudBees AWS CLI Plugin which expects pip to be installed as user
RUN mkdir -p /home/jenkins/.local/bin/ \
  && ln -s /usr/local/bin/pip /home/jenkins/.local/bin/pip \
  && chown -R jenkins:jenkins /home/jenkins/.local

#====================================
# NODE JS
# See https://github.com/nodesource/distributions/blob/master/README.md
# See https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
#====================================
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get install -y nodejs \
    && apt-get clean

#====================================
# YARN, GRUNT, GULP
#====================================

RUN npm install --global grunt-cli yarn gulp

#====================================
# Kubernetes CLI
# See https://storage.googleapis.com/kubernetes-release/release/stable.txt
#====================================
RUN curl https://storage.googleapis.com/kubernetes-release/release/v1.16.1/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

#====================================
# OPENSHIFT V3 CLI
# Only install "oc" executable, don't install "openshift", "oadmin"...
# See https://github.com/openshift/origin/releases
#====================================
RUN mkdir /var/tmp/openshift \
      && wget -O - "https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz" \
      | tar -C /var/tmp/openshift --strip-components=1 -zxf - \
      && mv /var/tmp/openshift/oc /usr/local/bin \
     && rm -rf /var/tmp/openshift

#====================================
# JMETER
#====================================
RUN mkdir /opt/jmeter \
      && wget -O - "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.3.tgz" \
      | tar -xz --strip=1 -C /opt/jmeter

#====================================
# MYSQL CLIENT
#====================================
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    mysql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER jenkins

# for dev purpose
# USER root

ENTRYPOINT ["/opt/bin/entry_point.sh"]

EXPOSE 4444
