#!/bin/bash
set -e
if ! type "wget" > /dev/null; then
  echo "ERROR: Script needs wget to download latest IG Publisher. Please install wget."
  exit 1
fi
echo "Downloading most recent publisher - it's ~100 MB, so this may take a bit"
wget https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.publisher.jar -O input-cache/org.hl7.fhir.publisher.jar
echo "Done"
