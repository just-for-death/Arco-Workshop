# UserAssembly 2.6.0

## Resources

 * Yet none

See [1.1.0 UserAssembly](../dev_tools/110_data/UserAssembly.md) for use instructions of pdb/cs files.


## Meta

### OS

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 199475960 bytes                  |
| Modification date | 2022-03-19                       |
| md5sum            | d4b6529f83bd0516f3386db0df919d24 |

### CN

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 199475432 bytes                  |
| Modification date | 2022-03-19                       |
| md5sum            | 0bbee9647f5a7bf97559b0d2395ee46f |

## Addresses

Warning: Address is not the same as the byte offset in the binary.

| Function   | VAddr. OS | VAddr. CN | Description                              |
|------------|-----------|-----------|------------------------------------------|
| login func | 18198cd60 | 18198cd60 | Calls to UnityPlayer [24] indirectly (1) |
| part of ^  | 18198d2fc | 18198d2fc | Validation call #1 (2)                   |
| part of ^  | 18198d349 | 18198d349 | Validation call #2 (2)                   |


Detailed explanation:

**1:** See 1.1.0 backtrace log

**2:** Format:

	ptr[RAX] + 0x10 = 0x00
	ptr[RAX] + 0x18 = string length
	ptr[RAX] + 0x20 = UTF-8 string (`\0` terminated)
