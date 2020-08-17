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
