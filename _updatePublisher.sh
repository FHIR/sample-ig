#!/bin/bash
set -e
echo "Downloading most recent publisher - it's ~100 MB, so this may take a bit"
wget -P input-cache -N https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.publisher.jar
echo "Done"
