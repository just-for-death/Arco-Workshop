# mhyprot2 1.0.1 + 1.1.0

## Meta

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 1362048 bytes (+92168 to 1.0.0)  |
| Modification date | 2020-10-14                       |
| md5sum            | 6b2df08bacf640cc2ac6f20c76af07ee |


## Addresses

Warning: Address is not the same as the byte offset in the binary.

| # | Type     | Address | Description                     |
|---|----------|---------|---------------------------------|
| 1 |          | 0       | Unknown                         |

The mid 95% portion of the file is entirely program code.


## Behaviour

See also: https://github.com/leeza007/evil-mhyprot-cli


What "mhyprot2" registers:

1. PsSetCreateProcessNotifyRoutineEx
2. PsSetLoadImageNotifyRoutine
3. PsSetCreateThreadNotifyRoutine

What "mhyprot2" does:

1. Hides its process handle by ObRegisterCallbacks
2. Observing for csrss.exe injection.
3. Remove the process/thread object from all handle tables.
4. Write logs into `c:\windows\kmlog.log`
    * Example when GI crashes after the warning screen: https://pastebin.com/raw/XQkkZcJE

This service **was** disabled and removed by xLua before showing the login screen.

It no longer appears in 1.1.0 logs, hence the service continues to run after login (proof needed).


	> CALL sb_1184180413 = {
		[1] = {address to CreateProcessA()}
		[2] = 0
		[3] = "sc stop mhyprot2"
		{...}
	}
	< OUT  sb_1184180413 = {
		[1] = 1.0
	}
	> CALL sb_1184180413 = {
		[1] = {address to CreateProcessA()}
		[2] = 0
		[3] = "sc delete mhyprot2"
		{...}
	}
	< OUT  sb_1184180413 = {
		[1] = 1.0
	}
