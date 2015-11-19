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

module winkit.WindowImplMixin;


mixin template WindowImplMixin(bool isSciter = false)
{
public:
	import std.conv;
	import std.traits;
	import winkit.WinAPI;
	import winkit.Window;

	Window wnd;

	void Create(SIZE sz, wstring title, HWND parent = NULL, DWORD dwStyle = WS_OVERLAPPEDWINDOW, DWORD dwExStyle = 0)// frames
	{
		if(!s_cls)
			s_cls = RegisterClass();

		HWND hWnd = CreateWindowExW(
			dwExStyle,			// extended style
			cast(LPCWSTR) s_cls,// class
			title.ptr,			// window title
			dwStyle,			// normal style
			CW_USEDEFAULT, 0,	// position
			sz.cx, sz.cy,		// size
			parent,
			null,
			.GetModuleHandleW(null),
			null
		);

		assert(hWnd && wnd==hWnd);// wnd set at StartWndProc
	}
	
	void Create(POINT pt, SIZE sz, HWND parent, DWORD dwStyle = WS_CHILD | WS_VISIBLE, DWORD dwExStyle = 0)// childs
	{
		if(!s_cls)
			s_cls = RegisterClass();

		HWND hWnd = CreateWindowExW(
			dwExStyle,			// extended style
			cast(LPCWSTR) s_cls,// class
			null,				// window title
			dwStyle,			// normal style
			pt.x, pt.y,			// position
			sz.cx, sz.cy,		// size
			parent,
			null,
			.GetModuleHandleW(null),
			null
		);

		assert(hWnd && wnd==hWnd);// wnd set at StartWndProc
	}

	// Operations
	LRESULT DefWindowProc()
	{
		static if(isSciter)
		{
			import sciter.api;
			return SciterProc(m_CurrentMsg.hwnd, m_CurrentMsg.message, m_CurrentMsg.wParam, m_CurrentMsg.lParam);
		} else {
			return DefWindowProcW(m_CurrentMsg.hwnd, m_CurrentMsg.message, m_CurrentMsg.wParam, m_CurrentMsg.lParam);
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

		auto hInstance = .GetModuleHandleW(null);
		WNDCLASSEXW wcex;
		wcex.style			= CS_HREDRAW | CS_VREDRAW;
		wcex.lpfnWndProc	= &StartWndProc;
		wcex.cbClsExtra		= 0;
		wcex.cbWndExtra		= 0;
		wcex.hInstance		= hInstance;
		wcex.hIcon			= LoadIconW(hInstance, MAKEINTRESOURCEW(100));
		//wcex.hCursor		= .LoadCursor(null, IDC_ARROW);
		wcex.hbrBackground	= cast(HBRUSH)(COLOR_WINDOW+1);
		wcex.lpszMenuName	= null;
		wcex.lpszClassName	= to!wstring(FRAME_WNDCLS).ptr;
		wcex.hIconSm		= null;
		return .RegisterClassExW(&wcex);
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