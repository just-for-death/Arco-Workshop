# UserAssembly 2.1.0

## Resources

 * Yet none

See [1.1.0 UserAssembly](../dev_tools/110_data/UserAssembly.md) for use instructions of pdb/cs files.


## Meta

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 197557016 bytes (+ 9.8 MiB)      |
| Modification date | 2021-08-23                       |
| md5sum            | 1c1bf7c8239266fccc5e1346a899d131 |


## Addresses

Warning: Address is not the same as the byte offset in the binary.

| Function                                    | Address   | Description                              |
|---------------------------------------------|-----------|------------------------------------------|
| public void (string, uint = 0)              | 18208cc30 | Calls to UnityPlayer [24] indirectly (1) |
| part of ^                                   | 18208d17d | Validation call #1 (2)                   |
| part of ^                                   | 18208d1ca | Validation call #2 (2)                   |


Detailed explanation:

**1:** See 1.1.0 backtrace log

**2:** Format:

	ptr[RAX] + 0x10 = 0x00
	ptr[RAX] + 0x18 = string length
	ptr[RAX] + 0x20 = UTF-8 string (`\0` terminated)
