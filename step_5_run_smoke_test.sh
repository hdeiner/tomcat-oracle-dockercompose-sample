#!/usr/bin/env bash

figlet -w 160 -f small "Run smoke test"
curl -s http://localhost:8080/passwordAPI/passwordDB > temp
if grep -q "RESULT_SET" temp
then
    figlet -w 160 -f small "SMOKE TEST SUCCESS!!!"

else
    figlet -w 160 -f small "SMOKE TEST FAILURE!!!"
fi
rm temp