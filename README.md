ACTUAL SCITER VERSION: 3.3.0.7

OctodeskDesk app made with this lib: https://github.com/midiway/OctoDeskdex

For quick starting, download a [Sciter Bootstrap](http://misoftware.rs/Bootstrap/Download) package for the D language, which comes with this library already configured.

**Status**: after I started writing the [C# bindings](https://github.com/MISoftware/SciterSharp) for Sciter, I realized how a 100% object-orient wrapper around Sciter API is the best way to go for creating a user friendly abstraction. When I started this D-port, in my mind I would be making the equivalent of the C++ classes found in Sciter SDK which is OO btw but the naming of things is very confusing. So the next step for this D-port is to convert it to equivalent classes and names found in the C# port, however I am prioritizing the C# version which is getting Mono cross-platform support. This port will eventually get more attention for improvements and for having GTK support, but right now I am focusing the C# version.

## About

This library is a port of Sciter headers to the D language. [Sciter](http://sciter.com/download/) is a multi-platform HTML engine. So with this library you can create D desktop application using not just HTML, but all the features of Sciter: CSS3, SVG, scripintg, AJAX, ...

The code is very well tested, and constantly used in real world applications, so be assured that it will save you hours and hours of debugging time, AVs and data corruptions (all which I had to face myself =D). Has unittest coverage so, in DMD, compile it with the -unittest flag to run them.

For more Sciter related content visit my site at: http://misoftware.rs/

Platforms supported until now: **Windows 32bits only**
*(Linux GTX support is on the way)*

License: MIT License


## Structs and classes

This is a table of the available D classes/structs and their mapping over the types of the official SDK C++ headers:

<table>
<tr>
<th>D type</th>
<th>C++ equivalent type</th>
</tr>

<tr>
<td>
<i>module sciter.sciter_dom;</i><br>
<b>struct node</b><br>
<b>struct element</b>
</td>

<td>
<i>#include "sciter-x-dom.hpp"</i><br>
<b>class sciter::dom::node</b><br>
<b>class sciter::dom::element</b>
</td>
</tr>

<tr>
<td>
<i>module sciter.sciter_value;</i><br>
<b>struct json_value</b>
</td>

<td>
<i>#include "value.hpp"</i><br>
<b>sciter::value or VALUE</b>
</td>
</tr>

<tr>
<td>
<i>module sciter.dbg;</i><br>
<b>abstract class debug_output</b><br>
</td>

<td>
<i>#include "sciter-x-debug.h"</i><br>
<b>class sciter::debug_output</b><br>
</td>
</tr>

<tr>
<td>
<i>module sciter.host;</i><br>
<b>class SciterArchive</b><br>
<b>abstract class SciterWindowHost</b>
</td>

<td>
<i>#include "sciter-x-host-callback.h"</i><br>
<b>class sciter::archive</b><br>
<b>class sciter::host&lt;BASE&gt;</b>
</td>
</tr>

<tr>
<td>
<i>module sciter.behavior;</i><br>
<b>abstract class EventHandler</b>
</td>

<td>
<i>#include "sciter-x-behavior.h"</i><br>
<b>class sciter::event_handler</b>
</td>
</tr>
</table>

## Package content

```
dub.json					-> DUB package manifest
sciter32-import-lib.lib		-> **win32** only: DLL import lib
/samples					-> contains sample of complete GUI aplications making use of this library; samples starting with 'u' are universal ones and the same source code should compile in all supported platforms
/source						-> source code of this library, you should add this path to the compiler 'include path'
/source/sciter				-> D definitions of classes wraping the Sciter API
/source/sciter/interop		-> D types for Sciter ABI
/source/winkit				-> **win32** only: this are helper classes forming a basic WIN32 user GUI toolkit wrapping common things, like creating and manipulating HWND, message loops, and so on..
```

## Features

**host <-> UI communication idioms support**

As can be read [here](http://sciter.com/sciter-ui-application-architecture/), there are 3 commons idioms for information flow between the host application and TIScript UI code, all of which are supported in this D port. Here is how you would implement each one:

*1. get-requests*
 
To handle UI-to-logic calls you first define/extend a `EventHandler` class in the native side and attaches it to your `SciterWindowHost` native implementation.

The `Setup()` function below first creates the `SciterWindowHost` instance and calls `host.setup_callback()` to identify the native HWINDOW attached to it. Then it simply instantiates the `EventHandler` and uses `host.attach_evh()` to attach it to the host in order to start receiving events.

```D
import sciter.host;

class MyHost : SciterWindowHost { ... }

void Setup(HWINDOW wnd)
{
	auto host = new MyHost();
	host.setup_callback(wnd);

	auto evh = new MyHostEvh();
	host.attach_evh(evh);
}

```

Each time script executes code like this:

```JavaScript
var ret = view.Host_DoSomething(param1, param2);
```

it will invoke the `on_script_call()` method of your native `EventHandler`:


```D
import std.conv;
import sciter.behavior;
import sciter.behavior;

class MyHostEvh : EventHandler
{
	override bool on_script_call(HELEMENT he, SCRIPTING_METHOD_PARAMS* prms)
	{
		switch(to!string(prms.name))
		{
		case "Host_DoSomething":
			// TIScript values passed by UI side
			json_value param1 = json_value(prms.argv[0]);
			json_value param2 = json_value(prms.argv[1]);
			 
			prms.result = json_value("Meow!");// TIScript return value for UI side
			return true;
		}
	}
}
```

*2. application events*

Application can generate some events by itself to the UI script layer. With your native `SciterWindowHost` in place, you simply call it's `call_function()` method:

```D
MyHost host = ...;
json_value ret = host.call_function("View_DoSomething", json_value(true), json_value(1234), json_value("from native side"));// call_function() is a variadic function
```

*3. post-requests*

UI-to-logic post/asynchronous request allows script to call native side method and receive the result in a later time, asynchronously, preventing the UI thread from blocking. Call to native code includes reference to script function that will be executed when the requested data is available.

Your script side:

```JavaScript
view.Host_AsyncProcess(function(meow) {
		$(body).text = "Host processing done: " + meow;
});
```

Your native `EventHandler` shaw be something like:

```D
class PostEvh : EventHandler
{
	override bool on_script_call(HELEMENT he, SCRIPTING_METHOD_PARAMS* prms)
	{
		json_value jv_callback = prms.argv[0];

		// TODO:
		// do expensive work in another thread
		// or you can save the jv_callback in a global variable and call it in a later time

		jv_callback.call(
			json_value("Meow! from host")
		);
		return true;
	}
}
```


**`json_value` supports construction through associative arrays, for example:**

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

**`json_value` multi-threading guidelines:**

Be aware that `json_value` is a struct type, and it's destructor clears the associated Sciter VALUE. So if you need a `json_value` to survive when it goes out of scope (mainly in multi-threading scenarios), you must put it in the heap, not it the stack, so instead of:

```D
json_value jv = json_value(1234);
```

..you must:

```D
json_value* jv = new json_value(1234);
```

That's D my friend.


# Library usage - Win32

## 1. Configuring linker: sciter32-import-lib.lib import lib

You need to add the file 'sciter32-import-lib.lib' to the linker input in order to it find the functions definitions of the Sciter DLL. This is the import lib that you pass to the linker for making your executable statically link to the sciter32.dll exports.

This file was generated using 'coffimplib' app (ftp://ftp.digitalmars.com/coffimplib.zip and  http://www.digitalmars.com/ctg/coffimplib.html).


## 2. Compiling your code

Requirements:

- add every .d files under /source/sciter directory to the compiler input, that is, compile them together with your app others .d files
- add /source to the compiler include path
- add needed import statements like: ```import sciter.api```


Minimal code for creating a Sciter based HWND and loading a external .html file:

```D
import sciter.interop.sciter_x_types;
import sciter.api;

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

# Library usage - Linux

Requirements:

Sciter for Linux requires GTK+3 and libcurl. Just make sure to install GTK+3 developer package:

```bash
sudo apt-get install libgtk-3-dev
```
