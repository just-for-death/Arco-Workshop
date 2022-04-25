# UnityPlayer 2.6.0

## Meta

### OS

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 32978680 bytes (-2.5 MiB)        |
| Modification date | 2022-03-19                       |
| md5sum            | af82a646e947d2ba69bf0c7f2432454a |

### CN

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 32980200 bytes (-2.4 MiB)        |
| Modification date | 2022-03-19                       |
| md5sum            | 688800bf397aaf1d088116d2ff267bb8 |

## Addresses

Warning: Address is not the same as the byte offset in the binary.

| # | Type       | VAddr. OS | VAddr. CN | Description                      |
|---|------------|-----------|-----------|----------------------------------|
|  1| func       | 18167ae30 | 18167ae30 | Service init, RET patch          |
|   | func       | 18167add0 | 18167add0 | ^ parent function, JMP patch     |
|  2| func-part  | N/A       | N/A       | Service check routine, XOR patch |
|  3| func       | 18166b150 | 18166b150 | Validation call #1               |
| 24| func       | 18166b5a0 | 18166b5a0 | Validation call #2               |
|   | func       | 180fd4450 | 180fd4450 | device model getter, substituted |
