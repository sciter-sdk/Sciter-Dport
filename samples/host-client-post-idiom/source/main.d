import std.stdio;

import sciter.interop.sciter_x_types;
import sciter.api;
import sciter.host;
import sciter.behavior;
import sciter.sciter_value;


class PostHost : SciterWindowHost
{
}

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

	auto host = new PostHost();
	host.setup_callback(wnd);

	auto evh = new PostEvh();
	host.attach_evh(evh);

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