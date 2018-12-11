#!/usr/bin/env bash

echo "Build fresh war for Tomcat deployment"
mvn clean compile war:war

echo "Fix oracleConfig.properties to point to the tod_backend we will create"
sed -i -r 's/^url\=.*$/url=jdbc:oracle:thin:@dockerOracle:1521\/xe/g' oracleConfig.properties

echo "Bring up Docker Compose"
sudo -S <<< "password" docker-compose -f tod-compose.yml -p tod up -d

echo "Waiting for Oracle to start"
fifo=/tmp/tmpfifo.$$
mkfifo "${fifo}" || exit 1
sudo -S <<< "password" docker logs oracle --follow >${fifo} &
dockerpid=$! 
grep -m 1 "Oracle started successfully!" "${fifo}"
sudo -S <<< "password" kill -9 "${dockerpid}" 
rm "${fifo}"

echo "Create database schema and load sample data"
liquibase --changeLogFile=src/main/db/changelog.xml update

echo Smoke test
curl -s http://localhost:8080/passwordAPI/passwordDB > temp
if grep -q "RESULT_SET" temp
then
    echo "SMOKE TEST SUCCESS"

else
    echo "SMOKE TEST FAILURE!!!"
fi
rm temp

echo "Run integration tests"
mvn verify failsafe:integration-test

echo "Bring down Docker Compose"
sudo -S <<< "password" docker-compose -f tod-compose.yml -p tod down
