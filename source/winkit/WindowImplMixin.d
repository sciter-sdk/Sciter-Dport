// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with sciter-dport. If not, see http://www.gnu.org/licenses/.

module winkit.WindowImplMixin;

//import sciter.definitions.api;

mixin template WindowImplMixin(bool isSciter = false)
{
public:
	import std.conv;
	import std.traits;
	import core.sys.windows.core;
	import winkit.Window;

	Window wnd;

	void Create(SIZE sz, wstring title, HWND parent = NULL, DWORD dwStyle = WS_OVERLAPPEDWINDOW, DWORD dwExStyle = 0)// frames
	{
		if(!s_cls)
			s_cls = RegisterClass();

		HWND hWnd = CreateWindowEx(
			dwExStyle,			// extended style
			cast(LPCWSTR) s_cls,// class
			title.ptr,			// window title
			dwStyle,			// normal style
			CW_USEDEFAULT, 0,	// position
			sz.cx, sz.cy,		// size
			parent,
			null,
			.GetModuleHandle(null),
			null
		);

		assert(hWnd && wnd==hWnd);// wnd set at StartWndProc
	}
	
	void Create(POINT pt, SIZE sz, HWND parent, DWORD dwStyle = WS_CHILD | WS_VISIBLE, DWORD dwExStyle = 0)// childs
	{
		if(!s_cls)
			s_cls = RegisterClass();

		HWND hWnd = CreateWindowEx(
			dwExStyle,			// extended style
			cast(LPCWSTR) s_cls,// class
			null,				// window title
			dwStyle,			// normal style
			pt.x, pt.y,			// position
			sz.cx, sz.cy,		// size
			parent,
			null,
			.GetModuleHandle(null),
			null
		);

		assert(hWnd && wnd==hWnd);// wnd set at StartWndProc
	}

	// Operations
	LRESULT DefWindowProc()
	{
		static if(isSciter)
		{
			import sciter.definitions.api;
			return SciterProc(m_CurrentMsg.hwnd, m_CurrentMsg.message, m_CurrentMsg.wParam, m_CurrentMsg.lParam);
		} else {
			return DefWindowProc(m_CurrentMsg.hwnd, m_CurrentMsg.message, m_CurrentMsg.wParam, m_CurrentMsg.lParam);
		}
	}


// Internal ------------------------------------------------------------------------------
private:
	ATOM s_cls;

	/*static this()
	{
		s_cls = RegisterClass();
	}*/

	ATOM RegisterClass()
	{
		enum FRAME_WNDCLS	= "WinkitWindowClass-" ~ fullyQualifiedName!ProcessWindowMessage;

		auto hInstance = .GetModuleHandle(null);
		WNDCLASSEX wcex;
		wcex.style			= CS_HREDRAW | CS_VREDRAW;
		wcex.lpfnWndProc	= &StartWndProc;
		wcex.cbClsExtra		= 0;
		wcex.cbWndExtra		= 0;
		wcex.hInstance		= hInstance;
		wcex.hIcon			= LoadIcon(hInstance, MAKEINTRESOURCE(100));
		//wcex.hCursor		= .LoadCursor(null, IDC_ARROW);
		wcex.hbrBackground	= cast(HBRUSH)(COLOR_WINDOW+1);
		wcex.lpszMenuName	= null;
		wcex.lpszClassName	= to!wstring(FRAME_WNDCLS).ptr;
		wcex.hIconSm		= null;
		return .RegisterClassEx(&wcex);
	}
	
// messaging
	MSG m_CurrentMsg;

	LRESULT IntanceWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
	{
		m_CurrentMsg.hwnd = hWnd;
		m_CurrentMsg.message = message;
		m_CurrentMsg.wParam = wParam;
		m_CurrentMsg.lParam = lParam;

		LRESULT lResult;
		if( ProcessWindowMessage(message, wParam, lParam, lResult) )
			return lResult;
		return DefWindowProc();
	}

	extern(Windows) static LRESULT StaticWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
	{
		return IntanceWndProc(hWnd, message, wParam, lParam);
	}

	extern(Windows) static LRESULT StartWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
	{
		wnd = hWnd;
		wnd.SetWindowLongPtr(GWLP_WNDPROC, cast(LONG_PTR) &StaticWndProc);
		return IntanceWndProc(hWnd, message, wParam, lParam);
	}


// compile time checking
private:
	alias f_pwm = bool function(UINT message, WPARAM wParam, LPARAM lParam, ref LRESULT lResult);
	static assert( is(typeof(&ProcessWindowMessage) == f_pwm), "ProcessWindowMessage() function not declared or with wrong types" );
}