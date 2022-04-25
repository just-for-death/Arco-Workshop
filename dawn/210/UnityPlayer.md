# UnityPlayer 2.1.0

## Meta

| Type              | Value                            |
|-------------------|----------------------------------|
| Size              | 34342168 bytes                   |
| Modification date | 2021-08-23                       |
| md5sum            | 11fe3615965c22a8c4d999b94bf1334b |


## Addresses

Warning: Address is not the same as the byte offset in the binary.

| # | Type       | Address   | Description                            |
|---|------------|-----------|----------------------------------------|
|  1| func       | 1817f28c0 | Service init, RET patch                |
|   | func       | 1817f2850 | ^ parent function, JMP patch           |
|  3| func       | 1817e3800 | Validation call #1                     |
| 24| func       | 1817e3c50 | Validation call #2                     |
|   | func       | 18115a420 | device model getter, substituted       |


Detailed explanation:

**1:** Disappared in version 1.5.0
