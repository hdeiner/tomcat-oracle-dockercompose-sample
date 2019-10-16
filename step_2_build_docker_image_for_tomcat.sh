#!/usr/bin/env bash

figlet -f small -w 160 "Build Docker image for Tomcat"

cp target/passwordAPI.war src/iac-resources/docker-tomcat/.

docker rmi howarddeiner/tod-tomcat

docker build src/iac-resources/docker-tomcat -t howarddeiner/tod-tomcat

