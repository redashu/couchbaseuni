# couchbase ON containers 

## Dockerfile link for Couchbase COmmunity Edition 

==
https://github.com/couchbase/docker/blob/f17df7695bbd6efb756b90b683bd5f34d08b5708/community/couchbase-server/6.5.1/Dockerfile

===

## PUlling. docker. images

```
 8  docker pull couchbase
    9  docker pull couchbase:community-6.5.1
 ```
 
 ## COuchbase deployment in container
 
 ### create a custom Network for Static IP purpose 
 ```
 [ec2-user@ip-172-31-73-6 ~]$ docker  images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
couchbase           latest              8ba716c8cb65        5 days ago          1.18GB
couchbase           community-6.5.1     a9ef5507642b        3 weeks ago         827MB
java                latest              d23bdf5b1b1b        3 years ago         643MB
[ec2-user@ip-172-31-73-6 ~]$ docker   network  ls
NETWORK ID          NAME                DRIVER              SCOPE
3266dcecd02e        bridge              bridge              local
7811e4e2665b        host                host                local
e7d84201d153        none                null                local
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ docker   network  create  ashubr1  --subnet  192.168.1.0/24  
9239e29b0c80ddd5ff8a86db781dc12e8e4e0964241a2df8602eb1059782354f
[ec2-user@ip-172-31-73-6 ~]$ docker   network  ls
NETWORK ID          NAME                DRIVER              SCOPE
9239e29b0c80        ashubr1             bridge              local
3266dcecd02e        bridge              bridge              local
7811e4e2665b        host                host                local
67685160aa54        mubeenabrl          bridge              local
e7d84201d153        none                null              

```

## launching container

```
docker  run -d --name  ashucouchbase --restart always --memory 2048m  --cpus 1 -p 1110-1115:8091-8096 -p 2220-2221:11210-11211   --network ashubr1  --ip 192.168.1.100  couchbase

```

## checking logs 
```
[ec2-user@ip-172-31-73-6 ~]$ docker  logs  ashucouchbase  
Starting Couchbase Server -- Web UI available at http://<ip>:8091
and logs available in /opt/couchbase/var/lib/couchbase/logs

The maximum number of open files for the couchbase user is set too low (1024).
It must be at least 70000.

Normally this can be increased by adding the following lines to
/etc/security/limits.conf:

couchbase              soft    nofile                  <value>
couchbase              hard    nofile                  <value>

Where <value> is greater than 70000. The procedure may be totally
different if you're running so called "non-root/non-sudo install" or
if you've built Couchbase Server from source.

```

### logs location 
```
[ec2-user@ip-172-31-73-6 ~]$ docker  exec  -it  ashucouchbase  bash 
root@040e9b1c0a6c:/# 
root@040e9b1c0a6c:/# 
root@040e9b1c0a6c:/# cat   /etc/os-release 
NAME="Ubuntu"
VERSION="16.04.6 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.6 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
root@040e9b1c0a6c:/# cd   /opt/couchbase/
root@040e9b1c0a6c:/opt/couchbase# ls
LICENSE.txt  README.txt  VARIANT.txt  VERSION.txt  bin  etc  lib  manifest.xml  samples  share  var
root@040e9b1c0a6c:/opt/couchbase# cd  var/
root@040e9b1c0a6c:/opt/couchbase/var# ls
lib
root@040e9b1c0a6c:/opt/couchbase/var# cd  lib/
root@040e9b1c0a6c:/opt/couchbase/var/lib# ls
couchbase  moxi
root@040e9b1c0a6c:/opt/couchbase/var/lib# cd  couchbase/
root@040e9b1c0a6c:/opt/couchbase/var/lib/couchbase# ls
config                              couchbase-server.babysitter.node  couchbase-server.pid  data      ip        leader_lease  logs    stats
couchbase-server.babysitter.cookie  couchbase-server.node             crash                 initargs  isasl.pw  localtoken    ns_log  tmp
root@040e9b1c0a6c:/opt/couchbase/var/lib/couchbase# cd  logs/
root@040e9b1c0a6c:/opt/couchbase/var/lib/couchbase/logs# ls
babysitter.log  error.log        http_access_internal.log  mapreduce_errors.log      ns_couchdb.log  stats.log
couchdb.log     goxdcr.log       info.log                  memcached.log.000000.txt  rebalance       views.log
debug.log       http_access.log  json_rpc.log              metakv.log                reports.log     xdcr_target.log

```

## updating RAM if Required during conf set
```
 docker  update  ashucouchbase  --memory 3024m
 
 ```
 
## Bucket from Backend access at filesystem 

```
root@040e9b1c0a6c:/opt/couchbase# pwd
/opt/couchbase
root@040e9b1c0a6c:/opt/couchbase# ls
LICENSE.txt  README.txt  VARIANT.txt  VERSION.txt  bin  etc  lib  manifest.xml  samples  share  var
root@040e9b1c0a6c:/opt/couchbase# cd  var/
root@040e9b1c0a6c:/opt/couchbase/var# ls
lib
root@040e9b1c0a6c:/opt/couchbase/var# cd lib/
root@040e9b1c0a6c:/opt/couchbase/var/lib# ls
couchbase  moxi
root@040e9b1c0a6c:/opt/couchbase/var/lib# cd  couchbase/
root@040e9b1c0a6c:/opt/couchbase/var/lib/couchbase# ls
config                              couchbase-server.babysitter.node  couchbase-server.pid  data      ip_start  leader_lease  logs    stats
couchbase-server.babysitter.cookie  couchbase-server.node             crash                 initargs  isasl.pw  localtoken    ns_log  tmp
root@040e9b1c0a6c:/opt/couchbase/var/lib/couchbase# cd  data/
root@040e9b1c0a6c:/opt/couchbase/var/lib/couchbase/data# ls
@2i  @analytics  @fts  ashubucket1
root@040e9b1c0a6c:/opt/couchbase/var/lib/couchbase/data# ls
@2i  @analytics  @fts  ashubucket1
root@040e9b1c0a6c:/opt/couchbase/var/lib/couchbase/data# ls  -l
total 52
drwxr-x--- 4 couchbase couchbase    58 Aug 17 07:10 @2i
drwxrwx--- 3 couchbase couchbase    26 Aug 17 07:20 @analytics
drwxrwx--- 2 couchbase couchbase    23 Aug 17 07:20 @fts
drwxrwx--- 2 couchbase couchbase 28672 Aug 17 07:23 ashubucket1
root@040e9b1c0a6c:/opt/couchbase/var/lib/couchbase/data# ls ashubucket1/
0.couch.1     161.couch.1  246.couch.1  330.couch.1  415.couch.1  50.couch.1   585.couch.1  67.couch.1   754.couch.1  839.couch.1  923.couch.1
1.couch.1     162.couch.1  247.couch.1  331.couch.1  416.couch.1  500.couch.1  586.couch.1  670.couch.1  755.couch.1  84.couch.1   924.couch.1

```

# Docker volume and Network for Couchbase communitiy addition 

```
[ec2-user@ip-172-31-73-6 ~]$ docker  volume  create   ashudbvol 
ashudbvol

===
[ec2-user@ip-172-31-73-6 ~]$ docker  volume  inspect  ashudbvol 
[
    {
        "CreatedAt": "2020-08-17T09:02:19Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/ashudbvol/_data",
        "Name": "ashudbvol",
        "Options": {},
        "Scope": "local"
    }
]

====


docker  run -d --name  ashucouchbase --restart always --memory 4096M  --cpus 1 -p 1110-1115:8091-8096 -p 2220-2221:11210-11211   --network ashubr1  --ip 192.168.1.100 -v ashudbvol:/opt/couchbase:rw  couchbase:community-6.5.1

```

