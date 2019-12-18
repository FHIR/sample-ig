#!/bin/bash
set -e
if ! type "curl" > /dev/null; then
  echo "ERROR: Script needs curl to download latest IG Publisher. Please install curl."
  exit 1

publisher=./input-cache/org.hl7.fhir.publisher.jar
if test -f "$publisher"; then
        jarlocation="./input-cache/org.hl7.fhir.publisher.jar"
        echo "IG Publisher FOUND in input-cache"
else
        publisher=../org.hl7.fhir.publisher.jar
        upgrade=true
        if test -f "$publisher"; then
                echo "IG Publisher FOUND in parent folder"
                jarlocation="../org.hl7.fhir.publisher.jar"
                upgrade=true
        else
        echo IG Publisher NOT FOUND in input-cache or parent folder...
                jarlocation="./input-cache/org.hl7.fhir.publisher.jar"
                upgrade=true
        fi
fi

if $upgrade ; then
        read -r -p "Download? [y/N] " response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
        then
             echo "Downloading most recent publisher to $jarlocation - it's ~100 MB, so this may take a bit"
#             wget "https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.publisher.jar" -O "$jarlocation" 
			 curl https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.publisher.jar -o "$jarlocation" --create-dirs
        else
             echo cancel...
        fi
fi
