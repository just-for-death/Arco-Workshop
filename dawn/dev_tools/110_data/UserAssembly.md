# UserAssembly 1.1.0

## Resources

 * [global-metadata.dat](https://www.unknowncheats.me/forum/downloads.php?do=file&id=31548) (decrypted)
 * [global-metadata.pdb](https://notabug.org/Kowalski/GI-on-Linux/src/master/110/symbols/UserAssembly.7z)


Sorted by ease-to-use.

#### global-metadata.pdb

**Does not work on Linux**

Read-to-use debugging symbols, thanks to Kowalski.

Ghidra:

 * Linux: not supported
 * Windows: obtain the `msdia140.dll` file (2017 and 2019 Build Tools surely have it)
    * See `PATH/TO/ghidra/docs/README_PDB.html`

x64dbg:

 * Not tested yet. Should work.


#### *.cpp / *.h Headers

1. Download `global-metadata.dat`
2. Decode it using [Il2CppInspector](https://notabug.org/Krock/GI-on-Linux/src/master/TOOLS.md#il2cppinspector) (instructions)
3. `cpp/appdata/` will be generated along with a Python script
4. Proceed as described in [their README](https://github.com/djkaty/Il2CppInspector/blob/master/README.md)

Ghidra (not tested): change `MAXMEM` passed to `ghidraRun`. It will require more than 3 GiB.


#### *.cs Headers

Debugging symbols as *.cs or *.cpp from `global-metadata.dat`

1. Download `global-metadata.dat`
2. Decode it using [Il2CppDumper](https://notabug.org/Krock/GI-on-Linux/src/master/TOOLS.md#il2cppinspector) (instructions)
    * The official version does only work partially
    * Error thrown after generating `dump.cs`
3. Read `dump.cs` and look out for the VA (Virtual Address) numbers


## Meta

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 119925872 bytes                  |
| Modification date | 2020-11-03                       |
| md5sum            | 265e3191d082bdcac55eee8afe1a9a81 |


## Addresses

Warning: Address is not the same as the byte offset in the binary.

| Function                                    | Address  | Description                              |
|---------------------------------------------|----------|------------------------------------------|
| void JDOLLLDKIAH:Tick()                     | 1818F1080| Main game loop                           |
| void MLEIPCMPDNB:KKKFPCEAECG()              | 1810E21D0| irrelevant, error display func           |
| bool EMDOOJFMAFO:IIMKPKFHPBK(PKLNHBKFINC)   | 180F3EA50| irrelevant, error display func           |
| void EMDOOJFMAFO:CBMHKMIGHAP(DKIMLPCIKJE)   | 180F316E0| Displays error obj DKIMLPCIKJE           |
| HashAlgorithm.ComputeHash(Stream)           | 182EC2900| irrelevant                               |
| NativeMethods.GetProcAddress(IntPtr, string)| 183B02A70|                                          |
| static void (ref byte[], int)               | 18267e970| UDP enc/dec function (1)                 |
|                                             |          |                                          |
| RetChecksumInvalid = 31                     |  const   | Error 31-XXXX                            |
| LOGIN_PLAYER_LOGIN__FAIL = 4302             |  const   | Error XX-4302                            |
|                                             |          |                                          |
| void FNOBHGHDEFL(string, uint = 0)          | 1818e5a40| Calls to UnityPlayer [24] indirectly (2) |
| void FMIMJHLBKHF()                          | 180f39020| Game / scene manager function ^  related |
| part of JDOLLLDKIAH:FNOBHGHDEFL             | 1818e5f54| Is called on every door entering (3)     |


Detailed explanation:

**1:** According to humanik12 this function was located at UserAssembly+0x1640860 in version 1.0.1.
Searching for similar bytes led to this identical-looking function.

Calls to this function: (according to Cheat Engine)

 * 1x after the initial "warning" screen
 * 1x after clicking "Start" (after server selector)
 * ~8x after entering the door, until the error message is shown

**2:** See [backtrace](raw/backtrace_crypt.txt) log

**3:** Is called on both, modified and clean clients. Earlier code collects system information.


#### Error stack backtrace

**Stack backtrace of 31-4302, sent to the logging server:** (version 1.1.0)

	MoleMole.SuperDebug:LogToServerInternal(Boolean, String, LogType, Boolean, Int32, Int32)
	MoleMole.SuperDebug:LogToServer(LogType, String, Boolean, Int32, Boolean, Int32)
	MoleMole.SuperDebug:VeryImportantError(String, Boolean, Int32, Int32)
	EMDOOJFMAFO:CBMHKMIGHAP(DKIMLPCIKJE)
	EMDOOJFMAFO:IIMKPKFHPBK(PKLNHBKFINC)
	PHPNKGGINJA:ENLPMLLNNPL(PKLNHBKFINC, Boolean&)
	JDOLLLDKIAH:BELMLPGKIND(PKLNHBKFINC)
	System.Func`2:Invoke(T)
	MLEIPCMPDNB:KKKFPCEAECG() -> UserAssembly 1810E21D0
	JDOLLLDKIAH:Tick() -> UserAssembly, 0x1818F1080
	MoleMole.GameManager:MCDBNNFBPFM()
	MoleMole.GameManager:Update()

Function name source: `global-metadata.dat`
