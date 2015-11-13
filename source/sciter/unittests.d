// Copyright 2015 Ramon F. Mendes
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

/+
Module exclusive for complex unitesting Sciter features
+/
module sciter.unittests;

import sciter.interop.sciter_x_types;
import sciter.api;


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
		.SciterLoadHtml(wnd, cast(ubyte*)html.ptr, cast(int)html.length, null) || assert(false);

	import core.sys.windows.windows;
	cbk(wnd);
	ShowWindow(wnd, 1);
	PostQuitMessage(0);

	MSG msg;
	while( GetMessageA(&msg, null, 0, 0) )
	{
		TranslateMessage(&msg);
		DispatchMessageA(&msg);
	}
}