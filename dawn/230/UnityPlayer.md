# UnityPlayer 2.3.0

## Meta

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 31751784 bytes                   |
| Modification date | 2021-11-17                       |
| md5sum            | dbc22b32f297b0e75f658dc10e30969d |


## Addresses

Warning: Address is not the same as the byte offset in the binary.

| # | Type       | Address   | Description                            |
|---|------------|-----------|----------------------------------------|
|  1| func       | 1815b6140 | Service init, RET patch                |
|   | func       | 1815b60D0 | ^ parent function, JMP patch           |
|  3| func       | 1815a7100 | Validation call #1                     |
| 24| func       | 1815a7550 | Validation call #2                     |
|   | func       | 180f13740 | device model getter, substituted       |

