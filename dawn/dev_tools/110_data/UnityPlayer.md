# UnityPlayer 1.1.0

## Meta

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 33929328 bytes                   |
| Modification date | 2020-11-03                       |
| md5sum            | a85caddc4d1e5838f404956e99995d27 |


## Addresses

Warning: Address is not the same as the byte offset in the binary.

| # | Type       | Address   | Description                            |
|---|------------|-----------|----------------------------------------|
|  1| func       | 1814cee00 | mhyprot2.sys init                      |
|  ^| PUSH 40 55 | 1814ce7b0 | Patch: `3C` (RET), function skip       |
|  2| func       | tba       | Anticheat check routine (1)            |
|  ^| crash      | 181d71fc3 | Access violation when skipping mhyprot2|
|  ^| MOV 8B 28  | 181d71fc3 | Patch: `31 D2` (EDX=0)                 |
|  3| func       | ??        | Service control (unclear)              |
|  ^| ptr        | ??        | Pointer to service control function    |
|  4| func       | 180e638b0 | Windows version getter                 |
|  5| func       | 1807eb580 | printf("...", ...) to terminal         |
|  6| func       | 180e67e03 | === OUTPUTING STACK TRACE === function |
| 23| func       | 1814d9fe0 | Checks a single file file (integrity)  |
| 24| func       | 1814e4480 | Checks multiple files (integrity, 2)   |


Detailed explanation:

**1:** Earliest known OP-Code of this function. Is executed approx. 10 seconds after the "Warning" screen was shown.

**2:** See [backtrace](raw/backtrace_crypt.txt) log

* Uses `CERT_QUERY_CONTENT_PKCS7_SIGNED_EMBED`

