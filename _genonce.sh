#!/bin/bash
echo Checking internet connection...
wget -q --spider tx.fhir.org

if [ $? -eq 0 ]; then
    echo "Online"
    txoption=""
else
    echo "Offline"
    txoption="-tx n/a"
fi

echo "$txoption"

publisher=./input-cache/org.hl7.fhir.publisher.jar
if test -f "$publisher"; then
    JAVA -jar ./input-cache/org.hl7.fhir.publisher.jar -ig ig.ini $txoption

else
        publisher=../org.hl7.fhir.publisher.jar
        if test -f "$publisher"; then
            JAVA -jar ../org.hl7.fhir.publisher.jar -ig ig.ini $txoption
        else
        echo IG Publisher NOT FOUND in input-cache or parent folder... aborting
        fi
fi
