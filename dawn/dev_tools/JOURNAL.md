# Journal for 1.1.0


### Service

The [`mhyprot2.sys`](mhyprot2.md) service is started in [`UnityPlayer.dll`](UnityPlayer.md), and hash-checked against modifications when entering the door.

### Checksum = Error 31

UnityPlayer checks the following files:

 * All `*.exe`, `*.dll`, `*.sys` files (recursively)


What does it do?

1. You click the door after logging in
2. UserAssembly jumps -> UnityPlayer
3. For each file:
	1. call `CryptQueryObject`
	2. what does it to?
4. Returns to -> UserAssembly
5. Probably sends it over the network


![Process information](https://i.postimg.cc/rF348zG9/grafik.png)


### Network

Detailed information: [network.md](network.md)

1. A large majority of packets has the same length when comparing Windows and Linux.
2. Game data is transferred using UDP, security stuff seems to be done using TLSv1.2.
3. The Linux client begins loading the game data over UDP, but opens a connection to the logging server to report the error.

Note: All error messages are reported to them. I blocked the logging servers for now, just to be safe.

Error messages also contain a stack backtrace, see [UserAssembly](UserAssembly.md).





