This directory contains files relevant to the patch development.


Relevant game changes:

1.0.1
	(accidental) 10 day "no-service" period 

1.1.0
	"sc stop" & "sc delete" are no longer run on login

1.2.0
	xLua: Introduction of the sb_* check

1.3.0
	xLua: lparser.c is no longer included
	UserAssembly: Modified login function
	UnityPlayer: Random crash on certain systems (patched)

1.3.2
	UnityPlayer: Random crash fixed

1.4.0
	(no relevant changes)

1.5.0
	Patch: Removal of old/unnecessary patches. (checkout c50c174)
	UnityPlayer: "10 second" delayed crash no longer happens
	UnityPlayer: Various runtime and startup crashes

1.5.1
	UnityPlayer: Crashes fixed

1.6.0
	New library: HDiffPatch
	Launcher: Obfuscated web request params
	Removed crash logging of non-crashy events (startup)

1.6.1
	(no relevant changes)

2.0.0
	Crash report directory format changed from "crash_*" to "mihoyocrash_*"

2.1.0
2.2.0
	(no relevant changes)

2.3.0
	Patch: Removal of old/unnecessary patches. (checkout 32d6ee4)
	xLua: sb_* check is not called any more

2.4.0
	New library: mhypbase.dll (more anti-debugger code)
	UnityPlayer: "10 second" delayed crash occurs again, but on startup

2.5.0
	Removed library: mhypbase.dll
	New binaries: mhyprot3.Sys (+ garbage), Plugins/crashreport.exe, Plugins/metakeeper.dll
	UnityPlayer: delayed crash is gone again
	Partial use of HDiffPatch for game updates

2.6.0
	(no relevant changes)
