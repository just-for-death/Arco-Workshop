# UserAssembly 2.3.0

## Resources

 * Yet none

See [1.1.0 UserAssembly](../dev_tools/110_data/UserAssembly.md) for use instructions of pdb/cs files.


## Meta

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 192462440 bytes                  |
| Modification date | 2021-11-17                       |
| md5sum            | 5cdb6007b8fd19f1dac9dec73e417045 |


## Addresses

Warning: Address is not the same as the byte offset in the binary.

| Function                                    | Address   | Description                              |
|---------------------------------------------|-----------|------------------------------------------|
| public void (string, uint = 0)              | 181a83da0 | Calls to UnityPlayer [24] indirectly (1) |
| part of ^                                   | 181a842ed | Validation call #1 (2)                   |
| part of ^                                   | 181a8433a | Validation call #2 (2)                   |


Detailed explanation:

**1:** See 1.1.0 backtrace log

**2:** Format:

	ptr[RAX] + 0x10 = 0x00
	ptr[RAX] + 0x18 = string length
	ptr[RAX] + 0x20 = UTF-8 string (`\0` terminated)
