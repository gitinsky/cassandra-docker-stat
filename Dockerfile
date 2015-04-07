FROM dockerfile/java:oracle-java8

MAINTAINER Daniel Podolsky <dp@gitinsky.com>

ENV PKG_NAME apache-cassandra-2.1.4
ENV PKG_SHA1 e7283e873403d2e9dac24531d58df21246e5cf3f

RUN \
  cd / \
  && apt-get update -y \
  && apt-get install -y wget ca-certificates lua5.2 \
  && wget -O "/$PKG_NAME.tar.gz" "http://apache-mirror.rbc.ru/pub/apache/cassandra/2.1.4/$PKG_NAME-bin.tar.gz" \
  && echo "$PKG_SHA1 /$PKG_NAME.tar.gz" | sha1sum -c - \
  && tar xvzf $PKG_NAME.tar.gz \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f $PKG_NAME.tar.gz \
  && mv /$PKG_NAME /cassandra \
  && mv /cassandra/conf /cassandra/conf.orig

ADD cassandra/conf/cassandra.yaml.template /cassandra/conf/cassandra.yaml.template
ADD cassandra/conf/logback.xml.template /cassandra/conf/logback.xml.template
ADD cassandra/conf/cassandra-topology.properties.template /cassandra/conf/cassandra-topology.properties.template

ADD usr/local/bin/templater.lua /usr/local/bin/templater.lua
ADD usr/local/share/lua/5.2/fwwrt/simplelp.lua /usr/local/share/lua/5.2/fwwrt/simplelp.lua

ADD cassandra-autoconfig /cassandra-autoconfig

VOLUME ["/storage/data"]
VOLUME ["/storage/logs"]

EXPOSE 7000 7199 9042 9160 61621

CMD ["/cassandra-autoconfig"]
