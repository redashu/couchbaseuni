
#  K8s based couchbase 

## installing kubectl in client machine

```
[ec2-user@ip-172-31-73-6 ~]$ curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 42.0M  100 42.0M    0     0   100M      0 --:--:-- --:--:-- --:--:--  100M
[ec2-user@ip-172-31-73-6 ~]$ ls
couchbaseuni  deploysinglenode.sh  kubectl  ok
[ec2-user@ip-172-31-73-6 ~]$ sudo mv  kubectl  /usr/bin/
[ec2-user@ip-172-31-73-6 ~]$ sudo chmod +x  /usr/bin/kubectl 
[ec2-user@ip-172-31-73-6 ~]$ kubectl  version  --client 
Client Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.8", GitCommit:"9f2892aab98fe339f3bd70e3c470144299398ace", GitTreeState:"clean", BuildDate:"2020-08-13T16:12:48Z", GoVersion:"go1.13.15", Compiler:"gc", Platform:"linux/amd64"}

```

## Couchbase image changes and push on Docker hub 

```
[ec2-user@ip-172-31-73-6 mycouchbase]$ cat  Dockerfile 
FROM  couchbase:community-6.5.1
MAINTAINER  ashutoshh@linux.com
RUN  echo "couchbase              soft    nofile    75000"  >>/etc/security/limits.conf
RUN  echo "couchbase              hard    nofile    75000"  >>/etc/security/limits.conf

===
  161  docker build  -t   ashutoshh:couchbasece  . 
  162  docker tag  ashutoshh:couchbasece    dockerashu/ashutoshh:couchbasece 
  163  docker  login -u dockerashu 
  164  docker push    dockerashu/ashutoshh:couchbasece 
  165  docker  logout 

```

# K8s pod of couchbase 

```
 187  kubectl  run  ashu-pod1  --image=dockerashu/ashutoshh:couchbasece --port 8091 --dry-run=client -o yaml
  188  kubectl  run  ashu-pod1  --image=dockerashu/ashutoshh:couchbasece --port 8091 --dry-run=client -o yaml >ashupod1.yaml

---

[ec2-user@ip-172-31-73-6 couchbaseuni]$ cat  ashupod1.yaml 
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: ashu-pod1
  name: ashu-pod1
spec:
  containers:
  - image: dockerashu/ashutoshh:couchbasece
    name: ashu-pod1
    ports:
    - containerPort: 8091
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}


```

### creating. service 
```
[ec2-user@ip-172-31-73-6 couchbaseuni]$ kubectl  expose  pod  ashu-pod1  --type NodePort --port 1234 --target-port 8091 -n ashutoshh 
service/ashu-pod1 exposed
```


# Create personal namespace 

```
[ec2-user@ip-172-31-73-6 ~]$ kubectl  createa  namespace   ashutoshh 

```

# auto completion 
```
[ec2-user@ip-172-31-73-6 ~]$ vim    ~/.bashrc  
[ec2-user@ip-172-31-73-6 ~]$ cat  ~/.bashrc 
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
source  <(kubectl  completion bash)
[ec2-user@ip-172-31-73-6 ~]$ source  ~/.bashrc 
[ec2-user@ip-172-31-73-6 ~]$ kubectl  
alpha          attach         completion     create         edit           kustomize      plugin         run            uncordon
annotate       auth           config         delete         exec           label          port-forward   scale          version
api-resources  autoscale      convert        describe       explain        logs           proxy          set            wait
api-versions   certificate    cordon         diff           expose         options        replace        taint          
apply          cluster-info   cp             drain          get        

```

# Couchbase deployment using k8s deployment 

```
  249  kubectl  create  deployment  ashucouchdep1  --image=couchbase:community-6.5.1 --namespace ashutoshh --dry-run=client  -o yaml 
  250  kubectl  create  deployment  ashucouchdep1  --image=couchbase:community-6.5.1 --namespace ashutoshh --dry-run=client  -o yaml      >ashucouchdep.yml
  
  ===
  [ec2-user@ip-172-31-73-6 ~]$ cat  ashucouchdep.yml 
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:  #  labels of deploy 
    app: ashucouchdep1
  name: ashucouchdep1  # name of  deployment 
  namespace: ashutoshh  #  name of namespace 
spec:
  replicas: 1  # it will create RS  and RS  will create one POd 
  selector:
    matchLabels:
      app: ashucouchdep1
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: ashucouchdep1   #  this will be label of POD 
    spec:
      containers:
      - image: couchbase:community-6.5.1 # couchbase docker image  from Docker hub 
        name: couchbase  #  name of container 
        ports:
        - containerPort: 8091  #  client to Node port for couchbase 
        resources: {}
status: {}

=======

[ec2-user@ip-172-31-73-6 ~]$ kubectl  apply -f ashucouchdep.yml 
deployment.apps/ashucouchdep1 created

  ```
  
  ## check deployments 
  
  ```
  
  [ec2-user@ip-172-31-73-6 ~]$ kubectl  get  deployments -n ashutoshh 
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
ashucouchdep1   1/1     1            1           2m12s
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ kubectl   get  replicasets   -n  ashutoshh 
NAME                       DESIRED   CURRENT   READY   AGE
ashucouchdep1-6967888f67   1         1         1       2m24s
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ kubectl   get  rs   -n  ashutoshh 
NAME                       DESIRED   CURRENT   READY   AGE
ashucouchdep1-6967888f67   1         1         1       2m39s
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ kubectl   get  pods   -n  ashutoshh 
NAME                             READY   STATUS    RESTARTS   AGE
ashucouchdep1-6967888f67-7pc25   1/1     Running   0          2m47s

```

### checking worker node of pod
```
[ec2-user@ip-172-31-73-6 ~]$ kubectl  get  no 
NAME                            STATUS   ROLES    AGE   VERSION
ip-172-31-34-203.ec2.internal   Ready    master   27h   v1.18.8
ip-172-31-53-123.ec2.internal   Ready    <none>   27h   v1.18.8
ip-172-31-56-185.ec2.internal   Ready    <none>   27h   v1.18.8
ip-172-31-59-10.ec2.internal    Ready    <none>   27h   v1.18.8
ip-172-31-60-76.ec2.internal    Ready    <none>   27h   v1.18.8
[ec2-user@ip-172-31-73-6 ~]$ kubectl  get  pods  -o wide  -n ashutoshh 
NAME                             READY   STATUS    RESTARTS   AGE    IP              NODE                           NOMINATED NODE   READINESS GATES
ashucouchdep1-6967888f67-7pc25   1/1     Running   0          4m5s   192.168.30.80   ip-172-31-59-10.ec2.internal   <none>           <none>
[ec2-user@ip-172-31-73-6 ~]$ 

```
## Creating service of Deployment 
```
[ec2-user@ip-172-31-73-6 ~]$ kubectl   get   deploy  -n ashutoshh 
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
ashucouchdep1   1/1     1            1           29m
[ec2-user@ip-172-31-73-6 ~]$ 
              
[ec2-user@ip-172-31-73-6 ~]$ kubectl  expose  deployment  ashucouchdep1  --type  NodePort  --port  1231  --target-port 8091  --name ashusvc1  -n ashutoshh 
service/ashusvc1 exposed
[ec2-user@ip-172-31-73-6 ~]$ kubectl   get  svc  -n ashutoshh 
NAME       TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
ashusvc1   NodePort   10.100.69.164   <none>        1231:30575/TCP   6s

  
```
### creating deployment for another couchbase node to join 
```
kubectl  create  deployment  ashucouchjoinnode  --image=couchbase:community-6.5.1 --namespace ashutoshh --dry-run=client  -o yaml      >ashucouchjoin.yml
[ec2-user@ip-172-31-73-6 ~]$ kubectl  get   deploy  -n ashutoshh 
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
ashucouchdep1       1/1     1            1           46m
ashucouchjoinnode   1/1     1            1           11s

```

## setting credential from Rest API 
```
[ec2-user@ip-172-31-73-6 ~]$ kubectl   exec  -it ashucouchjoinnode-597c9f4c48-9cgsx  bash  -n ashutoshh 
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl kubectl exec [POD] -- [COMMAND] instead.
root@ashucouchjoinnode-597c9f4c48-9cgsx:/# 

root@ashucouchjoinnode-597c9f4c48-9cgsx:/# curl -v -X POST  http://127.0.0.1:8091//settings/web  -d port=8091 -d username=Administrator -d password=couchdb

```

### Now check join node ip and from webUI you can join it 

```
[ec2-user@ip-172-31-73-6 ~]$ kubectl   get  po  -n ashutoshh  -o wide
NAME                                 READY   STATUS    RESTARTS   AGE   IP                NODE                           NOMINATED NODE   READINESS GATES
ashucouchdep1-6967888f67-7pc25       1/1     Running   0          64m   192.168.30.80     ip-172-31-59-10.ec2.internal   <none>           <none>
ashucouchjoinnode-597c9f4c48-9cgsx   1/1     Running   0          18m   192.168.159.206   ip-172-31-60-76.ec2.internal   <none>           <none>

```

## scale join nodes

```
[ec2-user@ip-172-31-73-6 ~]$ kubectl  get  deploy -n ashutoshh 
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
ashucouchdep1       1/1     1            1           73m
ashucouchjoinnode   1/1     1            1           27m
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ kubectl  scale deployment  ashucouchjoinnode  --replicas=3  -n ashutoshh 
deployment.apps/ashucouchjoinnode scaled
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ 
[ec2-user@ip-172-31-73-6 ~]$ kubectl  get  deploy -n ashutoshh 
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
ashucouchdep1       1/1     1            1           73m
ashucouchjoinnode   3/3     3            3           27m
[ec2-user@ip-172-31-73-6 ~]$ kubectl  get po -o wide  -n ashutoshh 
NAME                                 READY   STATUS    RESTARTS   AGE   IP                NODE                            NOMINATED NODE   READINESS GATES
ashucouchdep1-6967888f67-7pc25       1/1     Running   0          74m   192.168.30.80     ip-172-31-59-10.ec2.internal    <none>           <none>
ashucouchjoinnode-597c9f4c48-9cgsx   1/1     Running   0          28m   192.168.159.206   ip-172-31-60-76.ec2.internal    <none>           <none>
ashucouchjoinnode-597c9f4c48-z5f2b   1/1     Running   0          21s   192.168.236.139   ip-172-31-56-185.ec2.internal   <none>           <none>
ashucouchjoinnode-597c9f4c48-z7lcl   1/1     Running   0          21s   192.168.30.89     ip-172-31-59-10.ec2.internal    <none>           <none>

```

## couchbase node add shell script

```
[ec2-user@ip-172-31-73-6 ~]$ cat joinnode.sh 
#!/bin/bash

#  setting  username  and  password 

curl -v   http://127.0.0.1:8091/node/controller/setupServices   -d services='kv%2Cn1ql%2Cindex'
curl -v -X POST  http://127.0.0.1:8091/settings/web  -d port=8091 -d username=Administrator -d password=couchdb

## setting  up   data serive 

# Now adding  to cluster  
#  check current ip of couchbase node 
IP=`hostname -i`
# you main node cluster ip 
couchmain='192.168.30.80'
couchbase-cli server-add -c $couchmain:8091  --username Administrator  --password redhat123 --server-add $IP:8091 --server-add-username Administrator --server-add-password couchdb 

```
