FROM  couchbase:community-6.5.1
MAINTAINER   ashutoshh@linux.com
RUN mkdir  /startcouchbase 
WORKDIR  /startcouchbase
COPY couchbasecluster.sh .
RUN  chmod +x  couchbasecluster.sh
ENTRYPOINT  ["./couchbasecluster.sh"] 
