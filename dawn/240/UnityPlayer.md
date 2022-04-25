# UnityPlayer 2.4.0

## Meta

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 32306968 bytes                   |
| Modification date | 2021-12-25                       |
| md5sum            | 63addffbe46d3c588e4ef5ec246365b0 |


## Addresses

Warning: Address is not the same as the byte offset in the binary.

| # | Type       | Address   | Description                            |
|---|------------|-----------|----------------------------------------|
|  1| func       | 18161ec70 | Service init, RET patch                |
|   | func       | 18161ec00 | ^ parent function, JMP patch           |
|  2| func-part  | xx        | Service check routine (1), XOR patch   |
|  3| func       | 18160f730 | Validation call #1                     |
| 24| func       | 18160fb80 | Validation call #2                     |
|   | func       | 180f7baf0 | device model getter, substituted       |

Detailed explanation:

**1:** Is executed on startup (logo screen). Similar code seen from version 1.0.0 up to 1.4.0.
