import sciter.interop.sciter_x_types;
import sciter.api;
import gtkc.gtk;

void main()
{
	gtk_init(null, null);
	
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
	
	gtk_main();
}