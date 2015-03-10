// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

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