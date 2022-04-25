# UserAssembly 2.5.0

## Resources

 * Yet none

See [1.1.0 UserAssembly](../dev_tools/110_data/UserAssembly.md) for use instructions of pdb/cs files.


## Meta

### OS

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 198449224 bytes                  |
| Modification date | 2022-01-25                       |
| md5sum            | 335ce252d822bc01b899ca5d7e90b02e |

### CN

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 198450504 bytes                  |
| Modification date | 2022-01-25                       |
| md5sum            | d5601182f1e48f4fdb5ba76c42ac8963 |

## Addresses

Warning: Address is not the same as the byte offset in the binary.

| Function   | VAddr. OS | VAddr. CN | Description                              |
|------------|-----------|-----------|------------------------------------------|
| login func | 18175bd10 | 18175bd10 | Calls to UnityPlayer [24] indirectly (1) |
| part of ^  | 18175c25d | 18175c25d | Validation call #1 (2)                   |
| part of ^  | 18175c2aa | 18175c2aa | Validation call #2 (2)                   |


Detailed explanation:

**1:** See 1.1.0 backtrace log

**2:** Format:

	ptr[RAX] + 0x10 = 0x00
	ptr[RAX] + 0x18 = string length
	ptr[RAX] + 0x20 = UTF-8 string (`\0` terminated)
