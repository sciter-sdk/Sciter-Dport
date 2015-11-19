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

module winkit.Window;

import winkit.WinAPI;


struct Window
{
public:
	this(HWND hWnd) { m_hWnd = hWnd; }
	
	HWND m_hWnd;
	alias m_hWnd this;// a.k.a. implicit cast operator to HWND

public:
	LRESULT SendMessage(UINT Msg, WPARAM wParam = 0, LPARAM lParam = 0)
		{ return .SendMessageW(m_hWnd, Msg, wParam, lParam); }

	LRESULT PostMessage(UINT Msg, WPARAM wParam = 0, LPARAM lParam = 0)
		{ return .PostMessageW(m_hWnd, Msg, wParam, lParam); }

	BOOL ShowWindow(in int nCmdShow = SW_SHOW)
		{ return .ShowWindow(m_hWnd, nCmdShow); }

	BOOL UpdateWindow() 
		{ return .UpdateWindow(m_hWnd); }

	BOOL Invalidate()
		{ return .InvalidateRect(m_hWnd, null, TRUE); }

	LONG_PTR GetWindowLongPtr(in int nIndex)
		{ return GetWindowLongPtrW(m_hWnd, nIndex); }

	LONG_PTR SetWindowLongPtr(in int nIndex, in int dwNewLong)
		{ return SetWindowLongPtrW(m_hWnd, nIndex, dwNewLong); }

	size_t GetStyle()
		{ return GetWindowLongPtrW(m_hWnd, GWL_STYLE); }

	size_t GetStyleEx()
		{ return GetWindowLongPtrW(m_hWnd, GWL_EXSTYLE); }

	BOOL ModifyStyle(DWORD dwRemove, DWORD dwAdd)
	{
		DWORD dwStyle = .GetWindowLongPtrW(m_hWnd, GWL_STYLE);
		DWORD dwNewStyle = (dwStyle & ~dwRemove) | dwAdd;
		if(dwStyle == dwNewStyle)
			return FALSE;

		.SetWindowLongPtrW(m_hWnd, GWL_STYLE, dwNewStyle);
		return TRUE;
	}

	BOOL ModifyStyleEx(DWORD dwRemove, DWORD dwAdd)
	{
		DWORD dwStyle = .GetWindowLongPtrW(m_hWnd, GWL_EXSTYLE);
		DWORD dwNewStyle = (dwStyle & ~dwRemove) | dwAdd;
		if(dwStyle == dwNewStyle)
			return FALSE;

		.SetWindowLongPtrW(m_hWnd, GWL_EXSTYLE, dwNewStyle);
		return TRUE;
	}
	
	HWND GetParent()
		{ return .GetParent(m_hWnd); }

	BOOL IsEnabled()
		{ return IsWindowEnabled(m_hWnd); }

	BOOL IsVisible()
		{ return IsWindowVisible(m_hWnd); }

	void CenterTopLevelWindow(HWND parent = GetDesktopWindow())
	{
		HWND hwndParent = parent;
		RECT rectWindow, rectParent;

		//assert(hwndParent!=NULL);
		.GetWindowRect(m_hWnd, &rectWindow);
		.GetWindowRect(hwndParent, &rectParent);

		int nWidth = rectWindow.right - rectWindow.left;
		int nHeight = rectWindow.bottom - rectWindow.top;

		int nX = ((rectParent.right - rectParent.left) - nWidth) / 2 + rectParent.left;
		int nY = ((rectParent.bottom - rectParent.top) - nHeight) / 2 + rectParent.top;

		int nScreenWidth = GetSystemMetrics(SM_CXSCREEN);
		int nScreenHeight = GetSystemMetrics(SM_CYSCREEN);

		if (nX < 0) nX = 0;
		if (nY < 0) nY = 0;
		if (nX + nWidth > nScreenWidth) nX = nScreenWidth - nWidth;
		if (nY + nHeight > nScreenHeight) nY = nScreenHeight - nHeight;

		MoveWindow(m_hWnd, nX, nY, nWidth, nHeight, FALSE);
	}

	/*void CenterOverWindow(HWND hWndWhere)
	{
		RECT rectWindow, rectParent;
		.GetWindowRect(m_hWnd, &rectWindow);
		.GetWindowRect(hwndParent, &rectParent);
	}*/

	BOOL SetWindowPos(HWND hWndInsertAfter, int x, int y, int cx, int cy, UINT flags)
		{ return .SetWindowPos(m_hWnd, hWndInsertAfter, x, y, cx, cy, flags); }
	BOOL SetWindowPos(POINT pt)// position
		{ return .SetWindowPos(m_hWnd, NULL, pt.x, pt.y, 0, 0, SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOSIZE); }
	BOOL SetWindowPos(SIZE sz)// size
		{ return .SetWindowPos(m_hWnd, NULL, 0, 0, sz.cx, sz.cy, SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOMOVE); }
	BOOL SetWindowPos(POINT pt, SIZE sz)// position and size
		{ return .SetWindowPos(m_hWnd, NULL, pt.x, pt.y, sz.cx, sz.cy, SWP_NOZORDER | SWP_NOACTIVATE); }

	RECT GetWindowRect()
	{
		RECT rc;
		.GetWindowRect(m_hWnd, &rc);
		return rc;
	}
	RECT GetClientRect()
	{
		RECT rc;
		.GetClientRect(m_hWnd, &rc);
		return rc;
	}
}