#!/usr/bin/env bash

figlet -w 160 -f small "Build Docker image for Oracle"
docker-compose -f tod-compose-oracle.yml -p tod up -d

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

figlet -w 160 -f small "Create database and sample data"
liquibase --changeLogFile=src/main/db/changelog.xml update

figlet -w 160 -f small "Commit Docker image for Oracle"
docker rmi howarddeiner/tod-oracle
docker commit oracle howarddeiner/tod-oracle

figlet -w 160 -f small "Bring down Docker dontainer for Oracle"
docker-compose -f tod-compose-oracle.yml -p tod down