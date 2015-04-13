gitinsky/cassandra-docker-stat
================

### based on

https://github.com/tobert/cassandra-docker

### Running

```
sudo docker build -t gitinsky/cassandra-stat https://github.com/gitinsky/cassandra-docker-stat.git

for ii in data logs commitlog saved_caches; do sudo mkdir -vp /storage/cassandra-stat/$ii; done

sudo docker run \
  -e MEM_PC=70 \
  -e CLUSTER_ADDRS="comma separated list of addresses" \
  -e CLUSTER_NAME=setup-filestore \
  -e NODE_NAME="$(hostname)" \
  -e NODE_EXT_ADDR="$(ip addr show dev eth0|grep -P '^\s*inet\s+'|tr '/' ' '|awk '{print $2}')" \
  -e NODE_INT_ADDR="$(ip addr show dev eth1|grep -P '^\s*inet\s+'|tr '/' ' '|awk '{print $2}')" \
  -p 7000:7000 -p 7199:7199 -p 9042:9042 -p 9160:9160 -p 61621:61621 \
  -v /storage/data:/storage/data \
  -v /storage/logs:/storage/logs \
  -v /storage/commitlog:/storage/commitlog \
  -v /storage/saved_caches:/storage/saved_caches \
  -t -i gitinsky/cassandra-oracle-java8-g1gc \
  ;
```
