#!/usr/bin/env bash

figlet -w 160 -f small "Run integration tests"
mvn verify failsafe:integration-test