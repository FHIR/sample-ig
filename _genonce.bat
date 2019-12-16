@echo off

echo Checking internet connection...
Ping tx.fhir.org -n 1 -w 1000 | findstr TTL && goto isonline
echo We're offline...
set txoption=-tx n/a
goto igpublish
:isonline
echo We're online
set txoption=

:igpublish


@SET JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

If exist "input-cache\org.hl7.fhir.publisher.jar" (
   JAVA -jar input-cache/org.hl7.fhir.publisher.jar -ig ig.ini %txoption%
) ELSE If exist "..\org.hl7.fhir.publisher.jar" (
   JAVA -jar ../org.hl7.fhir.publisher.jar -ig ig.ini %txoption%
   ) Else (
@ECHO IG Publisher NOT FOUND in input-cache or parent folder... aborting
 )

@PAUSE