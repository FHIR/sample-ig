#!/bin/bash
mkdir -p input-cache
cd input-cache
echo "Downloading most recent publisher - it's ~100 MB, so this may take a bit"
curl -o org.hl7.fhir.publisher.jar https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.publisher.jar
cd ..
echo "Done"