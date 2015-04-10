ACTUAL SCITER VERSION: 3.2.0.6


About
=====

A port of Sciter headers to the D Programming Language. The originals C headers can be found in the Sciter SDK downloadable here: http://www.terrainformatica.com/sciter/main.whtm

Platforms supported and tested: Windows 32bits only

Sample of usage in Win32:

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


Package content
===============

* dub.json						-> DUB package manifest
* sciter32-import-lib.lib		-> win32 only: DLL import lib
* /samples						-> contains sample of complete GUI aplications making use of this library; samples starting with 'u' are universal ones and the same source code should compile in all supported platforms
* /source						-> source code of this library, you should add this path to the compiler 'include path'
* /source/sciter				-> .d files directly in this folder are basically header files with only declarations, not definitions, that is, the .h files ported to D
* /source/sciter/definitions	-> .d files here are the actual definitions of everything, from support classes, to the actual API functions
* /source/winkit				-> win32 only: this are helper classes forming a basic WIN32 user GUI toolkit wrapping common things, like creating and manipulating HWND, message loops, and so on..


Headers Mapping
-------------

/source/sciter/definitions/dbg.d	-> sciter-x-debug.h  (08/12/2014)

TBD


Compiling in Win32
==================



Win32: sciter32-import-lib.lib
------------------------------

For compiling your app on Windows you need to pass this file for the linker to find the functions definitions of the Sciter DLL.

This file was generated using the 'coffimplib' app found at ftp://ftp.digitalmars.com/coffimplib.zip and documented at http://www.digitalmars.com/ctg/coffimplib.html.

This is the import lib that you pass to the linker parameters for making your executable statically link to the sciter32.dll exports.


Misc
----

* Has unittest coverage so, in DMD, compile it with the -unittest flag to run them.