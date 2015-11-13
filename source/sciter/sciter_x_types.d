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

module sciter.sciter_x_types;

public import sciter.definitions.types;


version(all)
{
	alias ubyte BYTE;
	alias char BOOL;
	alias int INT;
	alias uint UINT;
	alias UINT* LPUINT;
	alias const(BYTE)* LPCBYTE;

	alias ulong UINT64;
	alias long INT64;
	alias size_t UINT_PTR;

	alias wchar WCHAR;
	alias wchar* LPWSTR;
	alias const(wchar*) LPCWSTR;
	alias const(char*) LPCSTR;
	alias void VOID;
	alias void* LPVOID;

	enum : int
	{
		FALSE = 0,
		TRUE = 1,
	}


	struct POINT
	{
		int x;
		int y;
	}
	alias POINT* LPPOINT;

	struct SIZE
	{
		int cx;
		int cy;
	}
	alias SIZE* LPSIZE;

	struct RECT
	{
		int left;
		int top;
		int right;
		int bottom;
	}
	alias RECT* LPRECT;

	alias void* ID2D1RenderTarget;
	alias void* ID2D1Factory;
	alias void* IDWriteFactory;
}


version(Windows)
{
	import core.sys.windows.windows;

	alias UINT_PTR WPARAM;
    alias LONG_PTR LPARAM;
    alias LONG_PTR LRESULT;

	struct MSG {
		HWND        hwnd;
		UINT        message;
		WPARAM      wParam;
		LPARAM      lParam;
		DWORD       time;
		POINT       pt;
	}

	struct FILETIME {
		DWORD dwLowDateTime;
		DWORD dwHighDateTime;
	}

    alias void* HWND;
	alias HWND HWINDOW;
}
version(OSX)
{
	alias void* HWINDOW;// NSView*
}
version(linux)
{
	import gtkc.gtktypes;
	alias GtkWidget* HWINDOW;
}