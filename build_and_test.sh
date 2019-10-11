#!/usr/bin/env bash

figlet -w 160 -f small "Build fresh war for Tomcat deployment"
mvn clean compile war:war
mkdir -p deployment
cp target/passwordAPI.war deployment/.
cp oracleConfig.properties deployment/.
read -p "Press enter to continue"

figlet -w 160 -f small "Bring up Docker Containers for Oracle and Tomcat"
docker-compose -f tod-compose.yml -p tod up -d
read -p "Press enter to continue"

figlet -w 160 -f small "Waiting for Oracle to start"
while true ; do
  curl -s localhost:8081 > tmp.txt
  result=$(grep -c "DOCTYPE HTML PUBLIC" tmp.txt)
  if [ $result = 1 ] ; then
    echo "Oracle has started"
    break
  fi
  sleep 5
done
rm tmp.txt
read -p "Press enter to continue"

figlet -w 160 -f small "Create database schema and load sample data"
liquibase --changeLogFile=src/main/db/changelog.xml update
read -p "Press enter to continue"

figlet -w 160 -f small "Smoke test"
curl -s http://localhost:8080/passwordAPI/passwordDB > temp
if grep -q "RESULT_SET" temp
then
    echo "SMOKE TEST SUCCESS"

else
    echo "SMOKE TEST FAILURE!!!"
fi
rm temp
read -p "Press enter to continue"

figlet -w 160 -f small "Run integration tests"
mvn verify failsafe:integration-test
read -p "Press enter to continue"

figlet -w 160 -f small "Bring down Docker Containers for Oracle and Tomcat"
docker-compose -f tod-compose.yml -p tod down