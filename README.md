ACTUAL SCITER VERSION: 3.2.0.6


About
=====

This library is a port of Sciter headers to the D language. The originals C headers can be found in the Sciter SDK downloadable here: http://www.terrainformatica.com/sciter/main.whtm

The code is very well tested, and constantly used in real world applications, so be assured that it will save you hours and hours of debugging time, AVs and data corruptions (all which I had to face myself =D)

Platforms supported and tested: Windows 32bits, Linux 32bits


Package content
===============

* dub.json					-> DUB package manifest
* sciter32-import-lib.lib		-> win32 only: DLL import lib
* /samples					-> contains sample of complete GUI aplications making use of this library; samples starting with 'u' are universal ones and the same sources compiles for all supported platforms
* /source						-> source code of this library, you should add this path to the compiler 'include path'
* /source/sciter				-> .d files directly in this folder are basically header files with only declarations, not definitions, that is, the .h files ported to D
* /source/sciter/definitions	-> .d files here are the actual definitions of everything, from support classes, to the actual API functions
* /source/winkit				-> win32 only: this are helper classes forming a basic WIN32 user GUI toolkit wrapping common things, like creating and manipulating HWND, message loops, and so on


Win32: sciter32-import-lib.lib
------------------------------

For compiling your app on Windows you need to pass this file for the linker to find the functions definitions.

This file was generated using the 'coffimplib' app found at ftp://ftp.digitalmars.com/coffimplib.zip and documented at http://www.digitalmars.com/ctg/coffimplib.html.

This is the import lib that you pass to the linker parameters for making your executable statically link to the sciter32.dll exports.


Headers Maping
-------------

/source/sciter/definitions/dbg.d	-> sciter-x-debug.h  (08/12/2014)

TBD


Compiling
=========

In Ubuntu x64, to compile the 32 bits version:

install this:
sudo apt-get install g++-multilib (works)
OR
sudo apt-get install gcc-multilib (works)
sudo apt-get install ia32-libs-dev (works)

and run
dub --arch=x86


Misc
----

* Has unittest coverage so, in DMD, compile it with the -unittest flag to run them.
