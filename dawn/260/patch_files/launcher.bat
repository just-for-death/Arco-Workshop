@echo off

REM Notice: This file is overwritten for each patch for safety reasons.
REM         Hence, any manual changes will be overwritten by the next patch.

REM ============ AVOID CHANGES HERE ============

SET perr1=1
SET perr2=1
SET perr=0

REM Verify that the important hosts are blocked
setlocal EnableDelayedExpansion
FOR /f "delims=" %%i IN ('ping -n 1 -w 1 log-upload-os.mihoyo.com') DO (
	echo %%i | find "[0.0.0.0]" >nul
	IF !ERRORLEVEL! EQU 0 SET "perr1=0"
	echo %%i | find "could not find host" >nul
	IF !ERRORLEVEL! EQU 0 SET "perr1=0"
)
FOR /f "delims=" %%i IN ('ping -n 1 -w 1 overseauspider.yuanshen.com') DO (
	echo %%i | find "[0.0.0.0]" >nul
	IF !ERRORLEVEL! EQU 0 SET "perr2=0"
	echo %%i | find "could not find host" >nul
	IF !ERRORLEVEL! EQU 0 SET "perr2=0"
)

REM There's no OR operator for "IF"
IF %perr1% EQU 1 SET perr=1
IF %perr2% EQU 1 SET perr=1

IF %perr% NEQ 0 (
	REM Show the message to the user
	echo ERROR: Crucial domains are not blocked. Please re-run the patch script. >_error.txt
	notepad _error.txt
	del _error.txt
	exit
)

REM Emulate the games behaviour
copy mhyprot2.sys "%TEMP%\"
regedit mhyprot2_running.reg

REM Disable crash reporting
IF EXIST GenshinImpact_Data\upload_crash.exe (
	move "GenshinImpact_Data\upload_crash.exe" "GenshinImpact_Data\upload_crash.exe.bak"
)
IF EXIST GenshinImpact_Data\Plugins\crashreport.exe (
	move "GenshinImpact_Data\Plugins\crashreport.exe" "GenshinImpact_Data\Plugins\crashreport.exe.bak"
)

REM ============= Launch the game =============
REM https://docs.unity3d.com/Manual/CommandLineArguments.html
REM Append the arguments to the command: launcher.bat arg1 arg2 ...

start GenshinImpact.exe %*
