# UserAssembly 2.2.0

## Resources

 * Yet none

See [1.1.0 UserAssembly](../dev_tools/110_data/UserAssembly.md) for use instructions of pdb/cs files.


## Meta

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 188003944 bytes (- 9.1 MiB)      |
| Modification date | 2021-09-28                       |
| md5sum            | 51ef64a6b2019cc1470319cae6d0bb56 |


## Addresses

Warning: Address is not the same as the byte offset in the binary.

| Function                                    | Address   | Description                              |
|---------------------------------------------|-----------|------------------------------------------|
| public void (string, uint = 0)              | 1815afe40 | Calls to UnityPlayer [24] indirectly (1) |
| part of ^                                   | 1815b038d | Validation call #1 (2)                   |
| part of ^                                   | 1815b03da | Validation call #2 (2)                   |


Detailed explanation:

**1:** See 1.1.0 backtrace log

**2:** Format:

	ptr[RAX] + 0x10 = 0x00
	ptr[RAX] + 0x18 = string length
	ptr[RAX] + 0x20 = UTF-8 string (`\0` terminated)
