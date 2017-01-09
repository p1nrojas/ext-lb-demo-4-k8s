#!/bin/bash

echo "Sleeping 5 seconds..."
sleep 5
echo "starting test: curl http://$1:8080"
FAILS=0   
while true; do
    curl http://$1:8080
    if [ $FAILS -gt 10 ]; then
       echo "10 tests done. bye!"
       exit
    fi
    sleep 2
    FAILS=$[FAILS + 1]
done
