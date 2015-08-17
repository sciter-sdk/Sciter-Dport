// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

module winkit.Window;

import win32.core;


struct Window
{
public:
	this(HWND hWnd) { m_hWnd = hWnd; }
	
	HWND m_hWnd;
	alias m_hWnd this;// a.k.a. implicit cast operator to HWND

public:
	LRESULT SendMessage(UINT Msg, WPARAM wParam = 0, LPARAM lParam = 0)
		{ return .SendMessage(m_hWnd, Msg, wParam, lParam); }

	LRESULT PostMessage(UINT Msg, WPARAM wParam = 0, LPARAM lParam = 0)
		{ return .PostMessage(m_hWnd, Msg, wParam, lParam); }

	BOOL ShowWindow(in int nCmdShow = SW_SHOW)
		{ return .ShowWindow(m_hWnd, nCmdShow); }

	BOOL UpdateWindow() 
		{ return .UpdateWindow(m_hWnd); }

	BOOL Invalidate()
		{ return .InvalidateRect(m_hWnd, null, TRUE); }

	LONG_PTR GetWindowLongPtr(in int nIndex)
		{ return .GetWindowLongPtr(m_hWnd, nIndex); }

	LONG_PTR SetWindowLongPtr(in int nIndex, in LONG_PTR dwNewLong)
		{ return .SetWindowLongPtr(m_hWnd, nIndex, dwNewLong); }

	size_t GetStyle()
		{ return .GetWindowLongPtr(m_hWnd, GWL_STYLE); }

	size_t GetStyleEx()
		{ return .GetWindowLongPtr(m_hWnd, GWL_EXSTYLE); }

	BOOL ModifyStyle(DWORD dwRemove, DWORD dwAdd)
	{
		DWORD dwStyle = .GetWindowLong(m_hWnd, GWL_STYLE);
		DWORD dwNewStyle = (dwStyle & ~dwRemove) | dwAdd;
		if(dwStyle == dwNewStyle)
			return FALSE;

		.SetWindowLong(m_hWnd, GWL_STYLE, dwNewStyle);
		return TRUE;
	}

	BOOL ModifyStyleEx(DWORD dwRemove, DWORD dwAdd)
	{
		DWORD dwStyle = .GetWindowLong(m_hWnd, GWL_EXSTYLE);
		DWORD dwNewStyle = (dwStyle & ~dwRemove) | dwAdd;
		if(dwStyle == dwNewStyle)
			return FALSE;

		.SetWindowLong(m_hWnd, GWL_EXSTYLE, dwNewStyle);
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