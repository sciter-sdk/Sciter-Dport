ACTUAL SCITER VERSION: 3.3.0.4

OctodeskDesk app made with this lib: https://github.com/midiway/OctoDeskdex

About
=====

This library is a port of Sciter headers to the D language. The originals C headers can be found in the Sciter SDK downloadable here: http://www.terrainformatica.com/sciter/main.whtm

The code is very well tested, and constantly used in real world applications, so be assured that it will save you hours and hours of debugging time, AVs and data corruptions (all which I had to face myself =D)

Has unittest coverage so, in DMD, compile it with the -unittest flag to run them.

Platforms supported until now: **Windows 32bits only**
*(Linux GTX support is on the way)*

License: GNU GENERAL PUBLIC LICENSE Version 2


Package content
===============

```
dub.json					-> DUB package manifest
sciter32-import-lib.lib		-> **win32** only: DLL import lib
/samples					-> contains sample of complete GUI aplications making use of this library; samples starting with 'u' are universal ones and the same source code should compile in all supported platforms
/source						-> source code of this library, you should add this path to the compiler 'include path'
/source/sciter				-> .d files directly in this folder are basically header files with only declarations, not definitions, that is, the .h files ported to D
/source/sciter/definitions	-> .d files here are the actual definitions of everything, from support classes, to the actual API functions
/source/winkit				-> **win32** only: this are helper classes forming a basic WIN32 user GUI toolkit wrapping common things, like creating and manipulating HWND, message loops, and so on..
```

Mapping over the oficial SDK headers
------------------------------------

```
/source/sciter/definitions/dbg.d
- equivalent file -> sciter-x-debug.h
- classes ported: 
	sciter::debug_output				-> abstract class debug_output
	sciter::script_debugger_client		-> abstract class script_debugger_client
```
```
/source/sciter/definitions/sciter_value.d
- equivalent file -> value.hpp
- classes ported: 
	sciter::value						-> struct json_value
```

Features
--------

json_value supports construction through associative arrays, for example:

```D
void Foo()
{
	json_value jassoc1 = [
		"key1" : 1,
		"key2" : 2,
	];
	
	json_value jassoc2 = [
		"key1" : json_value(1),
		"key2" : json_value(2),
	];
}
```


Library usage (win32)
=====================

1. Configuring linker: sciter32-import-lib.lib import lib
---------------------------------------------------------

You need to add the file 'sciter32-import-lib.lib' to the linker input in order to it find the functions definitions of the Sciter DLL. This is the import lib that you pass to the linker for making your executable statically link to the sciter32.dll exports.

This file was generated using 'coffimplib' app (ftp://ftp.digitalmars.com/coffimplib.zip and  http://www.digitalmars.com/ctg/coffimplib.html).


2. Compiling your code
----------------------

Requirements:

- add every .d files under /source/sciter directory to the compiler input, that is, compile them together with your app others .d files
- add /source to the compiler include path
- add needed import statements like: ```import sciter.definitions.api```


Minimal code for creating a Sciter based HWND and loading a external .html file:
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