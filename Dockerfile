FROM relateiq/oracle-java8

MAINTAINER Daniel Podolsky <dp@gitinsky.com>

ENV PKG_VERSION 2.1.8
ENV PKG_NAME    apache-cassandra
ENV PKG_SHA1    8fc0b4763487656793e9cb6016b939e0260e057e

RUN \
  cd / \
  && apt-get update -y \
  && apt-get install -y lua5.2 \
  && wget -O "/$PKG_NAME.tar.gz" "http://apache-mirror.rbc.ru/pub/apache/cassandra/$PKG_VERSION/$PKG_NAME-$PKG_VERSION-bin.tar.gz" \
  && echo "$PKG_SHA1 /$PKG_NAME.tar.gz" | sha1sum -c - \
  && tar xvzf $PKG_NAME.tar.gz \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f $PKG_NAME.tar.gz \
  && mv /$PKG_NAME-$PKG_VERSION /cassandra \
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
