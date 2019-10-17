#!/bin/bash
echo "========================================================================"
echo "Downloading most recent publisher to:"
echo ~/Downloads/org.hl7.fhir.igpublisher.jar
echo "... it's ~100 MB, so this may take a bit"
echo "========================================================================"
mv ~/Downloads/org.hl7.fhir.igpublisher.jar ~/Downloads/org.hl7.fhir.igpublisher-old.jar
curl -L https://github.com/FHIR/latest-ig-publisher/raw/master/org.hl7.fhir.publisher.jar -o ~/Downloads/org.hl7.fhir.igpublisher.jar
echo "===========================   Done  ===================================="
sleep 3
