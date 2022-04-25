# UserAssembly 2.4.0

## Resources

 * Yet none

See [1.1.0 UserAssembly](../dev_tools/110_data/UserAssembly.md) for use instructions of pdb/cs files.


## Meta

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 191208216 bytes                  |
| Modification date | 2021-12-25                       |
| md5sum            | 689e601f057e75e6bba247b4d507e238 |


## Addresses

Warning: Address is not the same as the byte offset in the binary.

| Function                                    | Address   | Description                              |
|---------------------------------------------|-----------|------------------------------------------|
| public void (string, uint = 0)              | 1817508a0 | Calls to UnityPlayer [24] indirectly (1) |
| part of ^                                   | 181750ded | Validation call #1 (2)                   |
| part of ^                                   | 181750e3a | Validation call #2 (2)                   |


Detailed explanation:

**1:** See 1.1.0 backtrace log

**2:** Format:

	ptr[RAX] + 0x10 = 0x00
	ptr[RAX] + 0x18 = string length
	ptr[RAX] + 0x20 = UTF-8 string (`\0` terminated)
