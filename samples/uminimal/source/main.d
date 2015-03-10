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
	SciterSetOption(wnd, SCITER_RT_OPTIONS.SCITER_TRANSPARENT_WINDOW, 0);
	
	
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