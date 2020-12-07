FROM openjdk:11-slim-buster
MAINTAINER pjpires@gmail.com

# Export HTTP & Transport
EXPOSE 9200 9300

ENV VERSION 7.9.2

# Install Elasticsearch.

RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    ca-certificates \
    curl \
    gpg \
    sudo \
  && (curl -Lskj https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$VERSION-linux-aarch64.tar.gz | \
      gunzip -c - | tar xf - )  \
  && mv /elasticsearch-$VERSION /elasticsearch \
  && rm -rf $(find /elasticsearch | egrep "(\.(exe|bat)$|sigar/.*(dll|winnt|x86-linux|solaris|ia64|freebsd|macosx))")

# Volume for Elasticsearch data
VOLUME ["/data"]

# Copy configuration
COPY config /elasticsearch/config

# Copy run script
COPY run.sh /

CMD ["/run.sh"]
