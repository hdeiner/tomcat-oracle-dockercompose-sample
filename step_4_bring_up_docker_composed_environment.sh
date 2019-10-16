#!/usr/bin/env bash

figlet -w 160 -f small "Bring up Docker composed environment"

mkdir -p deployment
cp oracleConfig.properties deployment/.

docker-compose -f tod-compose-tomcat-oracle.yml -p tod up -d
docker logs tomcat 2> temp >/dev/null
deploys_start=$(grep -c "Deployment of web application archive \[/usr/local/tomcat/webapps/passwordAPI.war\] has finished" temp)

figlet -w 160 -f small "Waiting for Oracle to start"
while true ; do
  curl -s localhost:8081 > tmp.txt
  result=$(grep -c "DOCTYPE HTML PUBLIC" tmp.txt)
  if [ $result = 1 ] ; then
    figlet -w 160 -f small "Oracle has started"
    break
  fi
  sleep 5
done
rm tmp.txt

echo "Waiting for passwordAPI application to deploy"
while true ; do
  docker logs tomcat 2> temp >/dev/null
  deploys_current=$(grep -c "Deployment of web application archive \[/usr/local/tomcat/webapps/passwordAPI.war\] has finished" temp)
  if [ "$deploys_current" -gt "$deploys_start" ] ; then
    figlet -w 160 -f small "passwordAPI application has deployed"
    break
  fi
  sleep 5
done
rm temp
