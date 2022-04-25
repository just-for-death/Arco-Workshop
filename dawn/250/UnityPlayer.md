# UnityPlayer 2.5.0

## Meta

### OS

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 35555912 bytes (+3.1 MiB)        |
| Modification date | 2022-01-25                       |
| md5sum            | c61817c8246b018ba028b579a12a5a19 |

### CN

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 35542856 bytes (+3.1 MiB)        |
| Modification date | 2022-01-25                       |
| md5sum            | 7e266e6e080d8dad00b7e8753a7f4ac1 |

## Addresses

Warning: Address is not the same as the byte offset in the binary.

| # | Type       | VAddr. OS | VAddr. CN | Description                      |
|---|------------|-----------|-----------|----------------------------------|
|  1| func       | 1818ae1a0 | 1818ae1a0 | Service init, RET patch          |
|   | func       | 1818ae140 | 1818ae140 | ^ parent function, JMP patch     |
|  2| func-part  | N/A       | N/A       | Service check routine, XOR patch |
|  3| func       | 18189e820 | 18189e820 | Validation call #1               |
| 24| func       | 18189ec70 | 18189ec70 | Validation call #2               |
|   | func       | 1812091a0 | 1812091a0 | device model getter, substituted |
