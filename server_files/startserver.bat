@ECHO OFF
SETLOCAL

:BEGIN
CLS
COLOR 3F >nul 2>&1
SET MC_SYS32=%SYSTEMROOT%\SYSTEM32
REM Make batch directory the same as the directory it's being called from
REM For example, if "run as admin" the batch starting dir could be system32
CD "%~dp0" >nul 2>&1

:CHECKJAVA
ECHO INFO: Checking java installation...
ECHO.

REM If no Java is installed this line will catch it simply
java -version 2>&1 || GOTO JAVAERROR

ECHO.
IF %ERRORLEVEL% EQU 0 (
	ECHO INFO: Found 64-bit Java
	GOTO CHECK
) ELSE (
    GOTO JAVAERROR
)
:MAIN
REM If you do not have java 17/18 on your PATH you must replace java below with a direct link to a compatible local java install
REM Example - "C:\Utilities\Java\Adoptium\17\bin\java" -jar serverstarter-2.4.2.jar
java -jar serverstarter-2.4.2.jar
GOTO EOF

:CHECK
IF NOT EXIST "%cd%\serverstarter-2.4.2.jar" (
	ECHO serverstarter binary not found, downloading serverstarter using curl...
	curl -OL https://github.com/TeamAOF/ServerStarter/releases/download/v2.4.2/serverstarter-2.4.2.jar
	) ELSE (
		GOTO MAIN
)

IF NOT EXIST "%cd%\serverstarter-2.4.2.jar" (
	ECHO serverstarter binary not found, downloading serverstarter using bitsadmin...
	%SYSTEMROOT%\SYSTEM32\bitsadmin.exe /rawreturn /nowrap /transfer starter /dynamic /download /priority foreground https://github.com/TeamAOF/ServerStarter/releases/download/v2.4.2/serverstarter-2.4.2.jar "%cd%\serverstarter-2.4.2.jar"
	) ELSE (
		GOTO MAIN
)

IF NOT EXIST "%cd%\serverstarter-2.4.2.jar" (
	cls
	COLOR CF
	ECHO ERROR: COULD NOT DOWNLOAD REQUIRED FILES, PLEASE CHECK INTERNET CONNECTION
	GOTO EOF
	) ELSE (
		GOTO MAIN
)

:JAVAERROR
cls
COLOR CF
ECHO ERROR: Could not find 64-bit Java installed or in PATH

:EOF
pause