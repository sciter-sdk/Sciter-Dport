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

module sciter.sciter_x_def;

import sciter.sciter_x_types;

public import sciter.sciter_x_value;	// "sciter-x-value.h"
public import sciter.sciter_x_dom;		// "sciter-x-dom.h"


extern(Windows)// needed for the functions alias'es
{
	enum SciterResourceType : UINT
	{
		RT_DATA_HTML = 0,
		RT_DATA_IMAGE = 1,
		RT_DATA_STYLE = 2,
		RT_DATA_CURSOR = 3,
		RT_DATA_SCRIPT = 4,
		RT_DATA_RAW = 5,
	}

	//EXTERN_C LPCWSTR SCAPI SciterClassName();
	//EXTERN_C UINT  SCAPI SciterVersion(BOOL major);


	enum
	{
		LOAD_OK = 0,      // do default loading if data not set
		LOAD_DISCARD = 1, // discard request completely
		LOAD_DELAYED = 2, // data will be delivered later by the host
						  // Host application must call SciterDataReadyAsync(,,, requestId) on each LOAD_DELAYED request to avoid memory leaks.
	}

	const int SC_LOAD_DATA				= 0x01;
	const int SC_DATA_LOADED			= 0x02;
	const int SC_ATTACH_BEHAVIOR		= 0x04;
	const int SC_ENGINE_DESTROYED		= 0x05;
	const int SC_POSTED_NOTIFICATION	= 0x06;

	struct SCITER_CALLBACK_NOTIFICATION
	{
		UINT code;// SC_LOAD_DATA or SC_DATA_LOADED or ..
		HWINDOW hwnd;
	}
	alias SCITER_CALLBACK_NOTIFICATION* LPSCITER_CALLBACK_NOTIFICATION;
	alias LPSciterHostCallback = UINT function(LPSCITER_CALLBACK_NOTIFICATION pns, LPVOID callbackParam);


	struct SCN_LOAD_DATA
	{
		UINT code;				/**< [in] one of the codes above.*/
		HWINDOW hwnd;			/**< [in] HWINDOW of the window this callback was attached to.*/

		LPCWSTR  uri;			/**< [in] Zero terminated string, fully qualified uri, for example "http://server/folder/file.ext".*/

		LPCBYTE  outData;		/**< [in,out] pointer to loaded data to return. if data exists in the cache then this field contain pointer to it*/
		UINT     outDataSize;	/**< [in,out] loaded data size to return.*/
		UINT     dataType;		/**< [in] SciterResourceType */

		LPVOID   requestId;		/**< [in] request id that needs to be passed as is to the SciterDataReadyAsync call */

		HELEMENT principal;
		HELEMENT initiator;
	}
	alias SCN_LOAD_DATA* LPSCN_LOAD_DATA;

	struct SCN_DATA_LOADED
	{
		UINT code;			/**< [in] one of the codes above.*/
		HWINDOW hwnd;		/**< [in] HWINDOW of the window this callback was attached to.*/

		LPCWSTR	uri;		/**< [in] zero terminated string, fully qualified uri, for example "http://server/folder/file.ext".*/
		LPCBYTE	data;		/**< [in] pointer to loaded data.*/
		UINT	dataSize;	/**< [in] loaded data size (in bytes).*/
		UINT	dataType;	/**< [in] SciterResourceType */
		UINT	status;		/**< [in] 
							status = 0 (dataSize == 0) - unknown error. 
							status = 100..505 - http response status, Note: 200 - OK! 
							status > 12000 - wininet error code, see ERROR_INTERNET_*** in wininet.h
							*/
	}
	alias SCN_DATA_LOADED* LPSCN_DATA_LOADED;

	struct SCN_ATTACH_BEHAVIOR
	{
		UINT code;		/**< [in] one of the codes above.*/
		HWINDOW hwnd;	/**< [in] HWINDOW of the window this callback was attached to.*/

		HELEMENT elem;		/**< [in] target DOM element handle*/
		LPCSTR   behaviorName;	/**< [in] zero terminated string, string appears as value of CSS behavior:"???" attribute.*/

		ElementEventProc* elementProc;	/**< [out] pointer to ElementEventProc function.*/
		LPVOID			  elementTag;	/**< [out] tag value, passed as is into pointer ElementEventProc function.*/
	}
	alias SCN_ATTACH_BEHAVIOR* LPSCN_ATTACH_BEHAVIOR;

	struct SCN_ENGINE_DESTROYED
	{
		UINT code; /**< [in] one of the codes above.*/
		HWINDOW hwnd; /**< [in] HWINDOW of the window this callback was attached to.*/
	}
	alias SCN_ENGINE_DESTROYED* LPSCN_ENGINE_DESTROYED;

	struct SCN_POSTED_NOTIFICATION
	{
		UINT      code; /**< [in] one of the codes above.*/
		HWINDOW   hwnd; /**< [in] HWINDOW of the window this callback was attached to.*/
		UINT_PTR  wparam;
		UINT_PTR  lparam;
		UINT_PTR  lreturn;
	}

	alias SCN_POSTED_NOTIFICATION* LPSCN_POSTED_NOTIFICATION;


	//EXTERN_C BOOL SCAPI SciterDataReady(HWINDOW hwnd,LPCWSTR uri,LPCBYTE data, UINT dataLength);
	//EXTERN_C BOOL SCAPI SciterDataReadyAsync(HWINDOW hwnd,LPCWSTR uri, LPCBYTE data, UINT dataLength, LPVOID requestId);
	//EXTERN_C LRESULT SCAPI SciterProc(HWINDOW hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
	//EXTERN_C LRESULT SCAPI SciterProcND(HWINDOW hwnd, UINT msg, WPARAM wParam, LPARAM lParam, BOOL* pbHandled);
	//EXTERN_C BOOL SCAPI     SciterLoadFile(HWINDOW hWndSciter, LPCWSTR filename);
	//EXTERN_C BOOL SCAPI     SciterLoadHtml(HWINDOW hWndSciter, LPCBYTE html, UINT htmlSize, LPCWSTR baseUrl);
	//EXTERN_C VOID SCAPI     SciterSetCallback(HWINDOW hWndSciter, LPSciterHostCallback cb, LPVOID cbParam);
	//EXTERN_C BOOL SCAPI     SciterSetMasterCSS(LPCBYTE utf8, UINT numBytes);
	//EXTERN_C BOOL SCAPI     SciterAppendMasterCSS(LPCBYTE utf8, UINT numBytes);
	//EXTERN_C BOOL SCAPI     SciterSetCSS(HWINDOW hWndSciter, LPCBYTE utf8, UINT numBytes, LPCWSTR baseUrl, LPCWSTR mediaType);
	//EXTERN_C BOOL SCAPI     SciterSetMediaType(HWINDOW hWndSciter, LPCWSTR mediaType);
	//EXTERN_C BOOL SCAPI     SciterSetMediaVars(HWINDOW hWndSciter, const SCITER_VALUE *mediaVars);
	//EXTERN_C UINT SCAPI     SciterGetMinWidth(HWINDOW hWndSciter);
	//EXTERN_C UINT SCAPI     SciterGetMinHeight(HWINDOW hWndSciter, UINT width);
	//EXTERN_C BOOL SCAPI     SciterCall(HWINDOW hWnd, LPCSTR functionName, UINT argc, const SCITER_VALUE* argv, SCITER_VALUE* retval);
	//EXTERN_C BOOL SCAPI     SciterEval( HWINDOW hwnd, LPCWSTR script, UINT scriptLength, SCITER_VALUE* pretval);
	//EXTERN_C VOID SCAPI     SciterUpdateWindow(HWINDOW hwnd);
	//EXTERN_C BOOL SCAPI SciterTranslateMessage(MSG* lpMsg);

	enum SCRIPT_RUNTIME_FEATURES : UINT
	{
		ALLOW_FILE_IO = 0x00000001,
		ALLOW_SOCKET_IO = 0x00000002,
		ALLOW_EVAL = 0x00000004,
		ALLOW_SYSINFO = 0x00000008
	}

	enum GFX_LAYER : UINT
	{
		GFX_LAYER_GDI      = 1,
		GFX_LAYER_WARP     = 2,
		GFX_LAYER_D2D      = 3,
		GFX_LAYER_AUTO     = 0xFFFF,
	}

	enum SCITER_RT_OPTIONS : UINT
	{
		SCITER_SMOOTH_SCROLL = 1,		 // value:TRUE - enable, value:FALSE - disable, enabled by default
		SCITER_CONNECTION_TIMEOUT = 2,	 // value: milliseconds, connection timeout of http client
		SCITER_HTTPS_ERROR = 3,			 // value: 0 - drop connection, 1 - use builtin dialog, 2 - accept connection silently
		SCITER_FONT_SMOOTHING = 4,		 // value: 0 - system default, 1 - no smoothing, 2 - std smoothing, 3 - clear type

		SCITER_TRANSPARENT_WINDOW = 6,	// Windows Aero support, value: 
										// 0 - normal drawing, 
										// 1 - window has transparent background after calls DwmExtendFrameIntoClientArea() or DwmEnableBlurBehindWindow().
		SCITER_SET_GPU_BLACKLIST  = 7,	// hWnd = NULL,
										// value = LPCBYTE, json - GPU black list, see: gpu-blacklist.json resource.
		SCITER_SET_SCRIPT_RUNTIME_FEATURES = 8, // value - combination of SCRIPT_RUNTIME_FEATURES flags.
		SCITER_SET_GFX_LAYER = 9,		// hWnd = NULL, value - GFX_LAYER
		SCITER_SET_DEBUG_MODE = 10,		// hWnd, value - TRUE/FALSE
		SCITER_SET_UX_THEMING = 11,		// hWnd = NULL, value - BOOL, TRUE - the engine will use "unisex" theme that is common for all platforms. 
										// That UX theme is not using OS primitives for rendering input elements. Use it if you want exactly
										// the same (modulo fonts) look-n-feel on all platforms.

		SCITER_ALPHA_WINDOW  = 12,		// hWnd, value - TRUE/FALSE - window uses per pixel alpha (e.g. WS_EX_LAYERED/UpdateLayeredWindow() window)
	}
	//EXTERN_C BOOL SCAPI SciterSetOption(HWINDOW hWnd, UINT option, UINT_PTR value );
	//EXTERN_C VOID SCAPI SciterGetPPI(HWINDOW hWndSciter, UINT* px, UINT* py);
	//EXTERN_C BOOL SCAPI SciterGetViewExpando( HWINDOW hwnd, VALUE* pval );
	//EXTERN_C BOOL SCAPI SciterRenderD2D(HWINDOW hWndSciter, ID2D1RenderTarget* prt);
	//EXTERN_C BOOL SCAPI     SciterD2DFactory(ID2D1Factory ** ppf);
	//EXTERN_C BOOL SCAPI     SciterDWFactory(IDWriteFactory ** ppf);
	//EXTERN_C BOOL SCAPI     SciterGraphicsCaps(LPUINT pcaps);
	//EXTERN_C BOOL SCAPI     SciterSetHomeURL(HWINDOW hWndSciter, LPCWSTR baseUrl);
	
	
	version(Windows)
		alias SciterWindowDelegate = LRESULT function(HWINDOW hwnd, UINT msg, WPARAM wParam, LPARAM lParam, LPVOID pParam, BOOL* handled);
	version(linux)
		alias SciterWindowDelegate = void*;
	version(OSX)
		alias SciterWindowDelegate = void*;


	enum SCITER_CREATE_WINDOW_FLAGS : UINT
	{
		SW_CHILD      = (1 << 0), // child window only, if this flag is set all other flags ignored
		SW_TITLEBAR   = (1 << 1), // toplevel window, has titlebar
		SW_RESIZEABLE = (1 << 2), // has resizeable frame
		SW_TOOL       = (1 << 3), // is tool window
		SW_CONTROLS   = (1 << 4), // has minimize / maximize buttons
		SW_GLASSY     = (1 << 5), // glassy window ( DwmExtendFrameIntoClientArea on windows )
		SW_ALPHA      = (1 << 6), // transparent window ( e.g. WS_EX_LAYERED on Windows )
		SW_MAIN       = (1 << 7), // main window of the app, will terminate app on close
		SW_POPUP      = (1 << 8), // the window is created as topmost.
		SW_ENABLE_DEBUG = (1 << 9), // make this window inspector ready
		SW_OWNS_VM      = (1 << 10), // it has its own script VM
	}

	//EXTERN_C HWINDOW SCAPI  SciterCreateWindow( UINT creationFlags, LPRECT frame, SciterWindowDelegate* delegate, LPVOID delegateParam, HWINDOW parent);


	enum OUTPUT_SUBSYTEM : UINT
	{
		OT_DOM = 0,       // html parser & runtime
		OT_CSSS,          // csss! parser & runtime
		OT_CSS,           // css parser
		OT_TIS,           // TIS parser & runtime
	}
	enum OUTPUT_SEVERITY : UINT
	{
		OS_INFO,
		OS_WARNING,
		OS_ERROR,
	}

	alias DEBUG_OUTPUT_PROC = VOID function(LPVOID param, UINT subsystem /*OUTPUT_SUBSYTEMS*/, UINT severity /*OUTPUT_SEVERITY*/, LPCWSTR text, UINT text_length);

	//EXTERN_C VOID SCAPI SciterSetupDebugOutput(
	//                                           HWINDOW                  hwndOrNull,// HWINDOW or null if this is global output handler
	//                                           LPVOID                param,     // param to be passed "as is" to the pfOutput
	//                                           DEBUG_OUTPUT_PROC     pfOutput   // output function, output stream alike thing.
	//                                           );
}