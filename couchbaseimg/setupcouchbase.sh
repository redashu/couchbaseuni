#!/bin/bash 

#  start  process of couchbase community edition  and get tty for further commands 
/entrypoint.sh  couchbase-server   & 
sleep 5  #  hold time for  10 seconds 
# service data that node will store couchbase data inside it 
curl -v   http://127.0.0.1:8091/node/controller/setupServices   -d services='kv%2Cn1ql%2Cindex'

# setup authencation 
curl -v -X POST  http://127.0.0.1:8091/settings/web  -d port=8091 -d username=Administrator -d password=couchdb

# adding  this Node TO cluster 
# POd ip of current couchbase Node
couchnode_ip=`hostname -i`

#  assuming cluster Node IP  of couchbase 
echo  $couchbase_cluster_ip

#  adding  node couchbase cluster 
couchbase-cli server-add -c $couchbase_cluster_ip:8091  --username Administrator  --password redhat123 --server-add $couchnode_ip:8091 --server-add-username Administrator --server-add-password couchdb


#  to keep contianer running  just a dummy  program 
tail  -f   /dev/null

