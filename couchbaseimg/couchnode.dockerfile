FROM  couchbase:community-6.5.1
MAINTAINER   ashutoshh@linux.com
RUN mkdir  /startcouchbase 
WORKDIR  /startcouchbase
COPY setupcouchbase.sh .
RUN  chmod +x  setupcouchbase.sh
ENTRYPOINT  ["./setupcouchbase.sh"] 
