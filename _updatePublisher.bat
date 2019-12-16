@echo off

for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" set winver=10
if "%version%" == "6.3" set winver=8.1
if "%version%" == "6.2" set winver=8
if "%version%" == "6.1" set winver=7
if "%version%" == "6.0" set winver=vista

for %%x in ("%CD%") do set upper_path=%%~dpx
set current_path=%cd%

@Set location=
rem echo inputcachepath
rem echo "%current_path%\input-cache\org.hl7.fhir.publisher.jar"

If not exist "%current_path%\input-cache\org.hl7.fhir.publisher.jar" (
	If not exist "%upper_path%org.hl7.fhir.publisher.jar" ( 
	@ECHO IG Publisher is not in input-cache or parent folder...
	@Set filelocation="%current_path%\input-cache\org.hl7.fhir.publisher.jar"
	echo %filelocation%
   @goto:download

	) else (
		@ECHO IG Publisher FOUND in parent folder
		@Set location=parent
		@Set filelocation="%upper_path%org.hl7.fhir.publisher.jar"
        @set filelocationname=Parent folder
		echo %filelocation%
   @goto:upgrade
	
	)
	
) else (
	@ECHO IG Publisher FOUND in input-cache
	@Set location=cache
	@Set filelocation="%current_path%\input-cache\org.hl7.fhir.publisher.jar"
	@set filelocationname=Input Cache
	echo %filelocation%
   @goto:upgrade

)

echo Done
goto:eof

:upgrade
set /p overwrite="Overwrite? "
if /I "%overwrite%"=="Y" (
		goto:download
)

goto:eof

:download
set dlurl=https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.publisher.jar
@ECHO Downloading most recent publisher to %filelocationname% - it's ~100 MB, so this may take a bit

if /I "%winver%"=="10" (
	@POWERSHELL -command Invoke-WebRequest -Uri %dlurl% -Outfile %filelocation%
  )

if /I "%winver%"=="7" ( 
   bitsadmin /transfer GetPublisher /download /priority normal %dlurl% %filelocation% 
)


pause
:eof
