#!/usr/bin/env bash

figlet -w 160 -f small "Build fresh war for Tomcat deployment"
mvn clean compile war:war