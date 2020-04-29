@ECHO OFF

SETLOCAL

SET dlurl=https://storage.googleapis.com/ig-build/org.hl7.fhir.publisher.jar
SET publisher_jar=org.hl7.fhir.publisher.jar
SET input_cache_path=%CD%\input-cache\
SET skipPrompts=false

set update_bat_url=https://raw.githubusercontent.com/FHIR/sample-ig/master/_updatePublisher.bat
set gen_bat_url=https://raw.githubusercontent.com/FHIR/sample-ig/master/_genonce.bat
set gencont_bat_url=https://raw.githubusercontent.com/FHIR/sample-ig/master/_gencontinuous.bat
set gencont_sh_url=https://raw.githubusercontent.com/FHIR/sample-ig/master/_gencontinuous.sh
set gen_sh_url=https://raw.githubusercontent.com/FHIR/sample-ig/master/_genonce.sh
set update_sh_url=https://raw.githubusercontent.com/FHIR/sample-ig/master/_updatePublisher.sh

IF "%~1"=="/f" SET skipPrompts=true

ECHO "%skipPrompts%"


ECHO Checking internet connection...
PING tx.fhir.org -n 1 -w 1000 | FINDSTR TTL && GOTO isonline
ECHO We're offline, nothing to do...
GOTO end

:isonline
ECHO We're online


:processflags
SET ARG=%1
IF DEFINED ARG (
	IF "%ARG%"=="-f" SET FORCE=true
	IF "%ARG%"=="--force" SET FORCE=true
	SHIFT
	GOTO processflags
)

FOR %%x IN ("%CD%") DO SET upper_path=%%~dpx

IF NOT EXIST "%input_cache_path%%publisher_jar%" (
	IF NOT EXIST "%upper_path%%publisher_jar%" (
		SET jarlocation="%input_cache_path%%publisher_jar%"
		SET jarlocationname=Input Cache
		ECHO IG Publisher is not yet in input-cache or parent folder.
		REM we don't use jarlocation below because it will be empty because we're in a bracketed if statement
		GOTO create
	) ELSE (
		ECHO IG Publisher FOUND in parent folder
		SET jarlocation="%upper_path%%publisher_jar%"
		SET jarlocationname=Parent folder
		GOTO upgrade
	)
) ELSE (
	ECHO IG Publisher FOUND in input-cache
	SET jarlocation="%input_cache_path%%publisher_jar%"
	SET jarlocationname=Input Cache
	GOTO upgrade
)

:create
IF DEFINED FORCE (
	MKDIR "%input_cache_path%" 2> NUL
	GOTO download
)
ECHO Will place publisher jar here: %input_cache_path%%publisher_jar%
IF "%skipPrompts%"=="true" (
	SET create="Y"
) ELSE (
	SET /p create="Ok? (Y/N) "
)
IF /I "%create%"=="Y" (
	MKDIR "%input_cache_path%" 2> NUL
	GOTO download
)
GOTO done

:upgrade
IF "%skipPrompts%"=="true" (
	SET overwrite="Y"
) ELSE (
	SET /p overwrite="Overwrite %jarlocation%? (Y/N) "
)

IF /I "%overwrite%"=="Y" (
	GOTO download
)
GOTO done

:download
ECHO Downloading most recent publisher to %jarlocationname% - it's ~100 MB, so this may take a bit

FOR /f "tokens=4-5 delims=. " %%i IN ('ver') DO SET VERSION=%%i.%%j
IF "%version%" == "10.0" GOTO win10
IF "%version%" == "6.3" GOTO win8.1
IF "%version%" == "6.2" GOTO win8
IF "%version%" == "6.1" GOTO win7
IF "%version%" == "6.0" GOTO vista

ECHO Unrecognized version: %version%
GOTO done

:win10
CALL POWERSHELL -command if ('System.Net.WebClient' -as [type]) {(new-object System.Net.WebClient).DownloadFile(\"%dlurl%\",\"%jarlocation%\") } else { Invoke-WebRequest -Uri "%dlurl%" -Outfile "%jarlocation%" }

GOTO done

:win7
rem this may be triggering the antivirus - bitsadmin.exe is a known threat
rem CALL bitsadmin /transfer GetPublisher /download /priority normal "%dlurl%" "%jarlocation%"

rem this didn't work in win 10
rem CALL Start-BitsTransfer /priority normal "%dlurl%" "%jarlocation%"

rem this should work - untested
call (New-Object Net.WebClient).DownloadFile('%dlurl%', '%jarlocation%')
GOTO done

:win8.1
:win8
:vista
GOTO done



:done




ECHO Will place publisher jar here: %input_cache_path%%publisher_jar%
IF "%skipPrompts%"=="true" (
	SET updateScripts="Y"
) ELSE (
	SET /p updateScripts="Update scripts? (Y/N) "
)
IF /I "%updateScripts%"=="Y" (
	GOTO scripts
)
GOTO end


:scripts

REM Download all batch files (and this one with a new name)

SETLOCAL DisableDelayedExpansion

REM ==== For getting the sources online...


rem POWERSHELL -command if ('System.Net.WebClient' -as [type]) {(new-object System.Net.WebClient).DownloadFile(\"%update_sh_url%\",\"_updatePublisher.sh\") } else { Invoke-WebRequest -Uri "%update_sh_url%" -Outfile "_updatePublisher.new.sh" }


rem POWERSHELL -command if ('System.Net.WebClient' -as [type]) {(new-object System.Net.WebClient).DownloadFile(\"%gen_bat_url%\",\"_genonce.bat\") } else { Invoke-WebRequest -Uri "%gen_bat_url%" -Outfile "_genonce.bat" }

rem POWERSHELL -command if ('System.Net.WebClient' -as [type]) {(new-object System.Net.WebClient).DownloadFile(\"%gencont_bat_url%\",\"_gencontinuous.bat\") } else { Invoke-WebRequest -Uri "%gencont_bat_url%" -Outfile "_gencontinuous.bat" }

rem POWERSHELL -command if ('System.Net.WebClient' -as [type]) {(new-object System.Net.WebClient).DownloadFile(\"%gen_sh_url%\",\"_genonce.sh\") } else { Invoke-WebRequest -Uri "%gen_sh_url%" -Outfile "_genonce.sh" }

rem POWERSHELL -command if ('System.Net.WebClient' -as [type]) {(new-object System.Net.WebClient).DownloadFile(\"%gencont_sh_url%\",\"_gencontinuous.sh\") } else { Invoke-WebRequest -Uri "%gencont_sh_url%" -Outfile "_gencontinuous.sh" }

call POWERSHELL -command if ('System.Net.WebClient' -as [type]) {(new-object System.Net.WebClient).DownloadFile(\"%update_bat_url%\",\"_updatePublisher.new.bat\") } else { Invoke-WebRequest -Uri "%update_bat_url%" -Outfile "_updatePublisher.new.bat" }

if %ERRORLEVEL% == 0 goto next
echo "Errors encountered during execution.  Exited with status: %errorlevel%"
goto end
:next
ECHO Updating this file...
start copy /y "_updatePublisher.new.bat" "_updatePublisher2.bat" ^&^& del "_updatePublisher.new.bat" ^&^& exit
REM ============================

:end

IF "%skipPrompts%"=="true" (
  PAUSE
}
