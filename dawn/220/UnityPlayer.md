# UnityPlayer 2.2.0

## Meta

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 31631976 bytes                   |
| Modification date | 2021-09-28                       |
| md5sum            | 38746fe5dbdce04311c84b2394f03686 |


## Addresses

Warning: Address is not the same as the byte offset in the binary.

| # | Type       | Address   | Description                            |
|---|------------|-----------|----------------------------------------|
|  1| func       | 1815a4160 | Service init, RET patch                |
|   | func       | 1815a40f0 | ^ parent function, JMP patch           |
|  3| func       | 181594b20 | Validation call #1                     |
| 24| func       | 181594f70 | Validation call #2                     |
|   | func       | 18115a420 | device model getter, substituted       |

