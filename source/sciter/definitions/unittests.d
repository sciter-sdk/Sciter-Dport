// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

/+
Module exclusive for complex unitesting Sciter features
+/
module sciter.definitions.unittests;

import sciter.sciter_x_types;
import sciter.definitions.api;


version(Windows)
void UnittestWindow(void function(HWINDOW) cbk, string html = null)// add html string parameter
{
	// test window creation
	RECT frame;
	frame.right = 800;
	frame.bottom = 600;

	HWINDOW wnd = SciterCreateWindow(
									SCITER_CREATE_WINDOW_FLAGS.SW_TITLEBAR |
									SCITER_CREATE_WINDOW_FLAGS.SW_RESIZEABLE |
									SCITER_CREATE_WINDOW_FLAGS.SW_MAIN |
									SCITER_CREATE_WINDOW_FLAGS.SW_CONTROLS,
									&frame, null, null, null);

	if(html)
		.SciterLoadHtml(wnd, cast(ubyte*)html.ptr, html.length, null) || assert(false);

	import core.sys.windows.windows;
	cbk(wnd);
	ShowWindow(wnd, 1);

	MSG msg;
	PostQuitMessage(0);

	while( GetMessageA(&msg, null, 0, 0) )
	{
		TranslateMessage(&msg);
		DispatchMessageA(&msg);
	}
}