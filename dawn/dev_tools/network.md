# Network 1.1.0 Analysis

Headings are ordered by stage of the game.

Non-relevant addresses are censored after the second full stop (ex. `static.google.*` (just in case).

Sources:

 * mitmproxy: [1.0.1 Linux vs Windows](https://drive.google.com/file/d/1NRxE6aLqpsRAMOfMbDAgU8KkRzFpgHIR/view?usp=sharing)


### Hosts to block

See `patch.sh` of the current version.


### 1 Launcher

Connection type: entirely TCP / TLSv1.2

DNS requests:

 * `sdk-os-static.mihoyo.*`
 * `log-upload-os.mihoyo.*` 
 * `api-static.mihoyo.*` Game update information (trigger by launcher button)
 * `webstatic.mihoyo.*`
 * `genshin.mihoyo.*`


### 2 Startup & login

Connection type: TCP/TLSv1.2 and TCP/HTTP

DNS requests, sorted by appearance:

 * `dispatchosglobal.*` Server listing (required, error 4201)
 * `osasiadispatch.*` Asia server
 * `oseurodispatch.*` Europa server
 * `osusadispatch.*` USA server
 * `webstatic-sea.mihoyo.*` In-game news (optional)
 * `log-upload-os.mihoyo.*` Log server (optional)
 * `hk4e-sdk-os.mihoyo.*` Central login and sales server (required)
 * `hk4e-api-os.mihoyo.*` Announcements, alerts (optional)
 * `sdk-os-static.mihoyo.*` Accessed at late game / exit

In addition to a few unity3d hosts which have no effect when blacklisted in `/etc/hosts`.


#### Weird sanity check

GET `/perf/config/verify?device_id=MIHOYOSDK_DEVICE_ID&platform=2&name=PC_NAME`:

 * Host: `log-upload-os.mihoyo.*` (OS) or `log-upload.mihoyo.*` (CN)

Answer, for Windows and Linux:

	{
	  "code": -1,
	  "message": "not matched"
	}


### 3 Game data loader

Connection type: UDP

Untouched section until it becomes necessary.


### 4 Gameplay

* `autopatchhk.yuanshen.*` Presumably xLua/HotFix patch server


### 5 Crash reporter

Connection type: TCP/HTTP

POST request to `/log`:

 * Host: `overseauspider.yuanshen.*` or `uspider.yuanshen.*`
 * Data:

______
	{
	  "userName": "Test",    /* Constant */
	  "time": "YYYY-MM-DD hh:mm:ss.0000",
	  "frame": "",           /* Unclear, perhaps game frame count */
	  "stackTrace": "Log::Logger() ....", /* Partially readable backtrace */
	  "logStr": "[Login] OnPlayerLoginRsp: 31", /* Error 31-4302 or .. */
	  "logStr": "[Login] OnGetPlayerTokenRsp: 21", /* Error 21-4301 aka BANNED */
	  "logType": "Error",
	  "deviceName": "NX",    /* Unclear */
	  "deviceModel": "Wine (The Wine Project)",
	  "operatingSystem": "Windows 10  (10.0...",
	   /* ^ Data from HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion  */
	  "version": "1.0_rel OSRELWin1.0.1_...", /* Game version (bottom left) */
	  "exceptionSerialNum": "0",
	  "pos": "",             /* Unclear, perhaps position on the map */
	  "guid": "sha256 hash",
	  /* ^ Data from HKEY_CURRENT_USER\Software\miHoYoSDK\ MIHOYOSDK_DEVICE_ID */
	  "errorCode": "Default",
	  "errorCodeToPlatform": 4302, /* Error 31-4302 or .. */
	  "errorCodeToPlatform": 4301, /* Error 21-4301 aka BANNED */
	  "serverName": "os_euro"  /* European server */
	}
______

Answer, status 200 OK:

	{
	  "code": 0
	}