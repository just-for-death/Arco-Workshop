# Tools

This file lists useful applications to debug and modify the game code.

Helpful articles:

 * https://www.apriorit.com/dev-blog/367-anti-reverse-engineering-protection-techniques-to-use-before-releasing-software
 * https://blog.usejournal.com/reverse-engineering-of-a-mobile-game-part-2-they-updated-we-dumped-memory-27046efdfb85


## General tips before starting

1. Rename or replace "upload_crash.exe", just to make sure
2. Add the logging servers to your /etc/hosts file (see network.md)


## Misc

Small tools that might come handy.

 * vbindiff - Binary difference viewer
 * xdelta3 - Binary patch generator (cross-platform)
    * Make patch: `-e -s ORIG MOD PATCH.vcdiff`
    * Apply patch: `-d -s BAK PATCH.vcdiff MOD`
 * [PE Tools](https://github.com/petoolse/petools/) - File header editor
    * Change and enlarge executable code sections
    * Alternative: Ghidra's "Memory Map" dialogue


## Scripting / Coding

Use: Extend `110/lua_injection.lua`

Link: [`110/xLua.md`](https://notabug.org/Krock/GI-on-Linux/src/master/101/xLua.md)

 * Extend the script to make use of the [InjectFix](https://github.com/Tencent/InjectFix) API
 * Overwrite the network encoding/decoding function in `UserAssembly`
    * "Patch number": `0xe66f` (how to register this patch?)
 * More information: [`110/xLua.md`](./110/xLua.md)


## Ghidra

Use: Decompile and patch UnityPlayer.dll, C code preview

Link: https://ghidra-sre.org/

**Hints:**

 * Hotkey "G": Jump to address
 * Hotkey "Ctrl+Shift+G": Patch instruction
 * Hotkey "O": Export modified dll as **binary**
 * Script "EditBytesScript.java": Edit bytes directly, assign a shortcut
 * [FindCrypt script](https://github.com/d3v1l401/FindCrypt-Ghidra)
    * Nothing interesting found in `UnityPlayer.dll`
 * "Memory Map": Edit PE headers to append code to free spots in/after the file


## Il2CppInspector

Use: decrypted `global-metadata.dat` + `UserAssembly.dll` => debug information

Link: https://github.com/djkaty/Il2CppInspector

**Hints**:

 * GUI does currently not work in Wine
 * `WINEDEBUG=-all wine Il2CppInspector-cli.exe -m global-metadata.dat -i UserAssembly.dll -t Ghidra --unity-version 2017.4.30f1`
 * Requires at least 2.5 GiB free RAM
 * Takes a LOOOONG TIME to execute
    * `Generate C# code: 2'296.42 sec`
 * May be used to import into Ghidra or IDA Pro


### Il2CppDumper (fork)

A fork of the Il2CppInspector subcomponent.

Link: https://github.com/kagurazakasanae/Il2CppDumper-YuanShen

**Hints:**

 * Creates `dump.cs` for manual lookup
    * `VA: 0x18xxxxxxx` is the virtual memory address
 * Fails to generate data for direct Ghidra import


## Cheat Engine (CE)

Use: Set breakpoints, rudimentary backtraces

Link: https://www.cheatengine.org/downloads.php

*Only works partially on Linux!*

**Required settings:**

  * Edit -> Settings -> Debugger Options
     * Use "VEH Debugger"
     * Use "Page exceptions" (optional, only specifies the defaults)

Optional: copy & paste the x86_64 binary and rename it. That *might* avoid detection.


**"Debug" instructions:**

1. Run GI in suspend mode -> [PowerShell script](https://www.unknowncheats.me/forum/other-mmorpg-and-strategy/418492-genshin-impact-64.html)
    * Linux: use [suspend_start utility exe](suspend_start/)
2. CE: Open process GenshinImpact using "Attach to process"
3. "Memory View"
4. Go to address. (Ctrl+G) -> "UnityPlayer.dll+(7 hex chars ¹)"
5. Set Exception breakpoint
6. When `mhyprot2` is running, suspend_start cannot stop the application any more.
    *  Try [Process Hacker](https://processhacker.sourceforge.io/downloads.php) (as admin) -> "Resume"
7. Hope that the breakpoint works and check the backtrace

¹) The 7 digits correspond to the virtual memory offset, but with the first byte removed. 0x181234567 becomes 0x1234567


## x64dbg

Use: Debug processes, disassebling and memory modifications

Link: https://x64dbg.com/

*Currently does not work in Wine*

**Anti-anti-debug:** (thanks to 0x90, POL thread)

 * Standard PEB check (IsDebuggerPresent() etc)
    * `gs:[60]+2 = 0` (x64 `BeingDebugged` flag)
    * `gs:[60]+bc = 0` (x64 mask `0x70` indicates debugging)
 * CheckRemoteDebuggerPresent
    * `RDX = 0`
    * `RCX = 0`
 * NtQueryInformationProcess -> `RDX = 0x7 // RDX = 0x1e`
 * NtClose -> `RCX = 0xDEADCODE`
 * NtSetInformationThread -> `RDX = 0x11`

Alternatively: [ScyllaHide plugin](https://github.com/x64dbg/ScyllaHide)

 * Even when attaching to a process using the plugin, it is still detected as a debugger. Solutions?

Alternatively: TitanHide (see Issue#7 for binaries)

 * I cannot get this to run. Maybe you can get better results.


## mitmproxy

Use: Capture all TCP/TLS data

Link: https://mitmproxy.org/

**Hints:**

1. Run `mitmdump -w output_file.mitm` (regular user is okay)
2. `export {http,https,ftp}_proxy="http://127.0.0.1:8080"`
    * Windows: Change the network adaptor settings to use your IP as proxy
3. Run Genshin Impact
4. Replay logs: `mitmproxy -nr output_file.mitm`


## Wireshark

Use: Record network activities + UDP

This is pretty much useless now. On Windows the sysinternals "Process Monitor" is more helpful.

**Hints:**

 * Use wired connection to packets from other wireless devices
 * Close other application for clean logs


## Other attempts

#### Linux CLI

`WINEDEBUG=+relay`

Wine 5.19, UnityPlayer 1.0.1:

	Backtrace:
	=>0 0x000000007b638000 EntryPoint+0x3a0() in kernel32 (0x00000000050cfe58)
	  1 0x00000001808637b8 EntryPoint+0xfeae9208() in unityplayer (0x00000000050cfe58)
	  2 0x000000007b631e09 EntryPoint+0xffffffffffffffff() in kernel32 (0x00000000050cfe58)
	  3 0x000000007bc4b5cf EntryPoint+0xffffffffffffffff() in ntdll (0x00000000050cfe58)
	  4 0x000000007b601b66 EntryPoint+0xffffffffffffffff() in kernel32 (0x0000000000000000)
	  5 0x000000007bc5e9b3 EntryPoint+0xffffffffffffffff() in ntdll (0x0000000000000000)
	0x000000007b638000 EntryPoint+0x3a0 in kernel32: addb	(%rax),%al

`winedbg`

Detected as debugger

`gdb --args wine ...`

Cannot debug due to SIGTRAP being spammed on purpose.

Process stalls when SIGTRAP is ignored:

	handle SIGTRAP nostop
	handle SIGTRAP noprint
