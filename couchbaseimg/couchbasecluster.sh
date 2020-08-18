#!/bin/bash 

#  start  process of couchbase community edition  and get tty for further commands 
/entrypoint.sh  couchbase-server   & 
sleep 5  #  hold time for  10 seconds 
# service data that node will store couchbase cluster node 
curl -v   http://127.0.0.1:8091/node/controller/setupServices   -d services='kv%2Cn1ql%2Cindex%2Cfts'

# setup authencation   for  first  node that will be cluster node 
curl -v -X POST  http://127.0.0.1:8091/settings/web  -d port=8091 -d username=Administrator -d password=redhat123 

#  maintain tty process 
tail -f /dev/null  #  we  are  maintain  couchbase server  is foreground process
