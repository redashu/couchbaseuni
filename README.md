
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
