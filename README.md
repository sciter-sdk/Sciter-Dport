ACTUAL SCITER VERSION: 3.2.0.8


About
=====

This library is a port of Sciter headers to the D language. The originals C headers can be found in the Sciter SDK downloadable here: http://www.terrainformatica.com/sciter/main.whtm

The code is very well tested, and constantly used in real world applications, so be assured that it will save you hours and hours of debugging time, AVs and data corruptions (all which I had to face myself =D)

Platforms supported until now: **Windows 32bits only**
*(Linux GTX support is on the way)*


Package content
===============

* dub.json						-> DUB package manifest
* sciter32-import-lib.lib		-> **win32** only: DLL import lib
* /samples						-> contains sample of complete GUI aplications making use of this library; samples starting with 'u' are universal ones and the same source code should compile in all supported platforms
* /source						-> source code of this library, you should add this path to the compiler 'include path'
* /source/sciter				-> .d files directly in this folder are basically header files with only declarations, not definitions, that is, the .h files ported to D
* /source/sciter/definitions	-> .d files here are the actual definitions of everything, from support classes, to the actual API functions
* /source/winkit				-> **win32** only: this are helper classes forming a basic WIN32 user GUI toolkit wrapping common things, like creating and manipulating HWND, message loops, and so on..


Headers mapping over the oficial SDK headers
--------------------------------------------

/source/sciter/definitions/dbg.d	-> sciter-x-debug.h
TBD


Library usage (win32)
=====================

1. Configuring linker: sciter32-import-lib.lib import lib
---------------------------------------------------------

You need to add the file 'sciter32-import-lib.lib' to the linker input in order to it find the functions definitions of the Sciter DLL. This is the import lib that you pass to the linker for making your executable statically link to the sciter32.dll exports.

This file was generated using 'coffimplib' app (ftp://ftp.digitalmars.com/coffimplib.zip and  http://www.digitalmars.com/ctg/coffimplib.html).


2. Compiling your code
----------------------

Requirements:

-add every .d files under /source/sciter directory to the compiler input, that is, compile them together with your app others .d files

-add /source to the compiler include path

-add needed import statetems like: ```import sciter.definitions.api```


Minimal code for creating a Sciter based HWND and loading a HTML page:
```D
import sciter.sciter_x_types;
import sciter.definitions.api;

void main()
{
	RECT frame;
	frame.right = 800;
	frame.bottom = 600;

	HWINDOW wnd = SciterCreateWindow(
		SCITER_CREATE_WINDOW_FLAGS.SW_TITLEBAR |
		SCITER_CREATE_WINDOW_FLAGS.SW_RESIZEABLE |
		SCITER_CREATE_WINDOW_FLAGS.SW_MAIN |
		SCITER_CREATE_WINDOW_FLAGS.SW_CONTROLS,
		&frame, null, null, null);
		
	SciterLoadFile(wnd, "minimal.html");
	
	
	version(Windows)
	{
		import core.sys.windows.windows;
		
		ShowWindow(wnd, 1);
		
		MSG msg;
		while( GetMessageA(&msg, null, 0, 0) )
		{
			TranslateMessage(&msg);
			DispatchMessageA(&msg);
		}
	}
}
```
