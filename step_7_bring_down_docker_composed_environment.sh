#!/usr/bin/env bash

figlet -w 160 -f small "Bring down Docker composed environment"
docker-compose -f tod-compose-tomcat-oracle.yml -p tod down

rm -rf deployment/
rm -rf src/iac-resources/docker-tomcat/passwordAPI.war