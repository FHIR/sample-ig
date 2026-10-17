@ECHO OFF
SET publisher_jar=publisher.jar
SET input_cache_path=%CD%\input-cache
IF DEFINED FHIR_PUBLISHER_HOME (
	SET "publisher_home=%FHIR_PUBLISHER_HOME%"
) ELSE (
	SET "publisher_home=%USERPROFILE%\.fhir\tools\publisher"
)

ECHO Checking internet connection...
powershell -Command "try { $r=[System.Net.WebRequest]::Create('https://tx.fhir.org/r4/metadata'); $r.Timeout=4000; $r.GetResponse().Close(); exit 0 } catch { exit 1 }"
IF %ERRORLEVEL% EQU 0 GOTO isonline
ECHO We're offline...
SET txoption=-tx n/a
GOTO igpublish

:isonline
ECHO We're online
SET txoption=

:igpublish

SET JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

REM powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0get-tx-token.ps1"

IF EXIST "%input_cache_path%\%publisher_jar%" (
	JAVA -jar "%input_cache_path%\%publisher_jar%" -ig . %txoption% %*
) ELSE If exist "..\%publisher_jar%" (
	JAVA -jar "..\%publisher_jar%" -ig . %txoption% %*
) ELSE IF EXIST "%publisher_home%\%publisher_jar%" (
	JAVA -jar "%publisher_home%\%publisher_jar%" -ig . %txoption% %*
) ELSE (
	ECHO IG Publisher NOT FOUND in input-cache, parent folder, or FHIR publisher home.  Please run _updatePublisher.  Aborting...
)

PAUSE
