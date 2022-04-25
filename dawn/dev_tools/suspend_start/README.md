### Suspend Start

This application runs an application in suspended mode and allows resuming/suspending afterwards.

Compilers for Linux:

  * Tiny C compiler: https://bellard.org/tcc/
  * winegcc (requires "wine-*-dev" package)

Compiling:

    wine tcc -Wall suspend_start.c

Running:

    wine suspend_start.exe "C:/path/to/GenshinImpact.exe"
