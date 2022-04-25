# xLua 1.0.1 + 1.1.0

## Sources

 * `lua_injection.sh` Patch script for Lua
 	* Contain patch description
 * `lua_injection.lua` Custom script that is run 2x
    * first: while showing the startup logo (just few functions)
    * second: after showing the warning screen (API is available here)
    * Has to be named `no message`
    * Must be located in GI's working directory


## Meta

md5sum: 2ec35c55430c7fcd3b313df8cd105d9e


## Addresses

See `lua_injection.sh`


## API

See also:

 * [comment issue#4](https://notabug.org/Krock/GI-on-Linux/issues/4#issuecomment-22288) summary
 * [InjectFix](https://github.com/Tencent/InjectFix) repository
 * [xLua source](https://github.com/Tencent/xLua) if you're curious

This part does not document the entire API. Dump `_G` using the script (~400 KiB)

Honorable mentions:

 * `sb_1184180413("FUNCTION", args, ...)`
    * Executes any C function
 * `package.loaded["Hotfix/Hotfix"]`
    * Delayed. Available shortly after login screen
    * Function `HotfixDispatch(??)` might be interesting
