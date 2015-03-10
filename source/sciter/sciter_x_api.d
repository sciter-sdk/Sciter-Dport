// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

module sciter.sciter_x_api;

import sciter.sciter_x_types;

import sciter.sciter_x_def;
import sciter.sciter_x_behaviors;
import sciter.tiscript;

extern(Windows)
{
	ISciterAPI* SciterAPI();

	struct ISciterAPI
	{
		UINT _version;

		LPCWSTR	function() SciterClassName;
		UINT	function(BOOL major) SciterVersion;
		BOOL	function(HWINDOW hwnd, LPCWSTR uri, LPCBYTE data, UINT dataLength) SciterDataReady;
		BOOL	function(HWINDOW hwnd, LPCWSTR uri, LPCBYTE data, UINT dataLength, LPVOID requestId) SciterDataReadyAsync;
	version(Windows)
	{
		LRESULT	function(HWINDOW hwnd, UINT msg, WPARAM wParam, LPARAM lParam) SciterProc;
		LRESULT	function(HWINDOW hwnd, UINT msg, WPARAM wParam, LPARAM lParam, BOOL* pbHandled) SciterProcND;
	}
		BOOL	function(HWINDOW hWndSciter, LPCWSTR filename) SciterLoadFile;
		BOOL    function(HWINDOW hWndSciter, LPCBYTE html, UINT htmlSize, LPCWSTR baseUrl) SciterLoadHtml;
		VOID    function(HWINDOW hWndSciter, LPSciterHostCallback cb, LPVOID cbParam) SciterSetCallback;
		BOOL    function(LPCBYTE utf8, UINT numBytes) SciterSetMasterCSS;
		BOOL    function(LPCBYTE utf8, UINT numBytes) SciterAppendMasterCSS;
		BOOL    function(HWINDOW hWndSciter, LPCBYTE utf8, UINT numBytes, LPCWSTR baseUrl, LPCWSTR mediaType) SciterSetCSS;
		BOOL    function(HWINDOW hWndSciter, LPCWSTR mediaType) SciterSetMediaType;
		BOOL    function(HWINDOW hWndSciter, const SCITER_VALUE *mediaVars) SciterSetMediaVars;
		UINT    function(HWINDOW hWndSciter) SciterGetMinWidth;
		UINT    function(HWINDOW hWndSciter, UINT width) SciterGetMinHeight;
		BOOL    function(HWINDOW hWnd, LPCSTR functionName, UINT argc, const SCITER_VALUE* argv, SCITER_VALUE* retval) SciterCall;
		BOOL    function(HWINDOW hwnd, LPCWSTR script, UINT scriptLength, SCITER_VALUE* pretval) SciterEval;
		VOID    function(HWINDOW hwnd) SciterUpdateWindow;
	version(Windows)
		BOOL	function(MSG* lpMsg) SciterTranslateMessage;
		BOOL    function(HWINDOW hWnd, UINT option, UINT_PTR value ) SciterSetOption;
		VOID    function(HWINDOW hWndSciter, UINT* px, UINT* py) SciterGetPPI;
		BOOL    function(HWINDOW hwnd, VALUE* pval ) SciterGetViewExpando;
		BOOL    function(HWINDOW hWndSciter, URL_DATA_RECEIVER receiver, LPVOID param, LPCSTR url) SciterEnumUrlData;
	version(Windows)
	{
		BOOL	 function(HWINDOW hWndSciter, ID2D1RenderTarget* prt) SciterRenderD2D;
		BOOL	 function(ID2D1Factory ** ppf) SciterD2DFactory;
		BOOL	 function(IDWriteFactory ** ppf) SciterDWFactory;
	}
		BOOL    function(LPUINT pcaps) SciterGraphicsCaps;
		BOOL    function(HWINDOW hWndSciter, LPCWSTR baseUrl) SciterSetHomeURL;
	version(OSX)
		HWINDOW function( LPRECT frame ) SciterCreateNSView;// returns NSView*
		HWINDOW	function(UINT creationFlags,LPRECT frame, SciterWindowDelegate* delegt, LPVOID delegateParam, HWINDOW parent) SciterCreateWindow;
		VOID	function(
						 HWINDOW               hwndOrNull,// HWINDOW or null if this is global output handler
						LPVOID                param,     // param to be passed "as is" to the pfOutput
						DEBUG_OUTPUT_PROC     pfOutput   // output function, output stream alike thing.
						) SciterSetupDebugOutput;
		BOOL	function(
						HWINDOW						hwnd,      // HWINDOW of the sciter
						LPVOID						param,     // param to be passed "as is" to these functions:
						SCITER_DEBUG_BP_HIT_CB		onBreakpointHit,  // breakpoint hit event receiver
						SCITER_DEBUG_DATA_CB		onDataRead        // receiver of requested data
						) SciterDebugSetupClient;
		BOOL	function(
						HWINDOW		hwnd,      // HWINDOW of the sciter
						LPCWSTR		fileUrl,                    
						UINT		lineNo
						) SciterDebugAddBreakpoint;
		BOOL	function(
						 HWINDOW	hwnd,      // HWINDOW of the sciter
						LPCWSTR		fileUrl,                    
						UINT		lineNo
						) SciterDebugRemoveBreakpoint;
		BOOL	function(
						HWINDOW                     hwnd,      // HWINDOW of the sciter
						LPVOID                      param,     // param to be passed "as is" to the pfOutput
						SCITER_DEBUG_BREAKPOINT_CB  receiver
						) SciterDebugEnumBreakpoints;

		//|
		//| DOM Element API 
		//|
		SCDOM_RESULT function(HELEMENT he) Sciter_UseElement;
		SCDOM_RESULT function(HELEMENT he) Sciter_UnuseElement;
		SCDOM_RESULT function(HWINDOW hwnd, HELEMENT *phe) SciterGetRootElement;
		SCDOM_RESULT function(HWINDOW hwnd, HELEMENT *phe) SciterGetFocusElement;
		SCDOM_RESULT function(HWINDOW hwnd, POINT pt, HELEMENT* phe) SciterFindElement;
		SCDOM_RESULT function(HELEMENT he, UINT* count) SciterGetChildrenCount;
		SCDOM_RESULT function(HELEMENT he, UINT n, HELEMENT* phe) SciterGetNthChild;
		SCDOM_RESULT function(HELEMENT he, HELEMENT* p_parent_he) SciterGetParentElement;
		SCDOM_RESULT function(HELEMENT he, BOOL outer, LPCBYTE_RECEIVER rcv, LPVOID rcv_param) SciterGetElementHtmlCB;
		SCDOM_RESULT function(HELEMENT he, LPCWSTR_RECEIVER rcv, LPVOID rcv_param) SciterGetElementTextCB;
		SCDOM_RESULT function(HELEMENT he, LPCWSTR utf16, UINT length) SciterSetElementText;
		SCDOM_RESULT function(HELEMENT he, LPUINT p_count) SciterGetAttributeCount;
		SCDOM_RESULT function(HELEMENT he, UINT n, LPCSTR_RECEIVER rcv, LPVOID rcv_param) SciterGetNthAttributeNameCB;
		SCDOM_RESULT function(HELEMENT he, UINT n, LPCWSTR_RECEIVER rcv, LPVOID rcv_param) SciterGetNthAttributeValueCB;
		SCDOM_RESULT function(HELEMENT he, LPCSTR name, LPCWSTR_RECEIVER rcv, LPVOID rcv_param) SciterGetAttributeByNameCB;
		SCDOM_RESULT function(HELEMENT he, LPCSTR name, LPCWSTR value) SciterSetAttributeByName;
		SCDOM_RESULT function(HELEMENT he) SciterClearAttributes;
		SCDOM_RESULT function(HELEMENT he, LPUINT p_index) SciterGetElementIndex;
		SCDOM_RESULT function(HELEMENT he, LPCSTR* p_type) SciterGetElementType;
		SCDOM_RESULT function(HELEMENT he, LPCSTR_RECEIVER rcv, LPVOID rcv_param) SciterGetElementTypeCB;
		SCDOM_RESULT function(HELEMENT he, LPCSTR name, LPCWSTR_RECEIVER* rcv, LPVOID rcv_param) SciterGetStyleAttributeCB;
		SCDOM_RESULT function(HELEMENT he, LPCSTR name, LPCWSTR value) SciterSetStyleAttribute;
		SCDOM_RESULT function(HELEMENT he, LPRECT p_location, UINT areas /*ELEMENT_AREAS*/) SciterGetElementLocation;
		SCDOM_RESULT function(HELEMENT he, UINT SciterScrollFlags) SciterScrollToView;
		SCDOM_RESULT function(HELEMENT he, BOOL andForceRender) SciterUpdateElement;
		SCDOM_RESULT function(HELEMENT he, RECT rc) SciterRefreshElementArea;
		SCDOM_RESULT function(HELEMENT he) SciterSetCapture;
		SCDOM_RESULT function(HELEMENT he) SciterReleaseCapture;
		SCDOM_RESULT function(HELEMENT he, HWINDOW* p_hwnd, BOOL rootWindow) SciterGetElementHwnd;
		SCDOM_RESULT function(HELEMENT he, LPWSTR szUrlBuffer, UINT UrlBufferSize) SciterCombineURL;
		SCDOM_RESULT function(HELEMENT  he, LPCSTR    CSS_selectors, SciterElementCallback callback, LPVOID param) SciterSelectElements;
		SCDOM_RESULT function(HELEMENT  he, LPCWSTR   CSS_selectors, SciterElementCallback callback, LPVOID param) SciterSelectElementsW;
		SCDOM_RESULT function(HELEMENT  he, LPCSTR    selector, UINT      depth, HELEMENT* heFound) SciterSelectParent;
		SCDOM_RESULT function(HELEMENT  he, LPCWSTR   selector, UINT      depth, HELEMENT* heFound) SciterSelectParentW;
		SCDOM_RESULT function(HELEMENT he, const BYTE* html, UINT htmlLength, UINT where) SciterSetElementHtml;
		SCDOM_RESULT function(HELEMENT he, UINT* puid) SciterGetElementUID;
		SCDOM_RESULT function(HWINDOW hwnd, UINT uid, HELEMENT* phe) SciterGetElementByUID;
		SCDOM_RESULT function(HELEMENT hePopup, HELEMENT heAnchor, UINT placement) SciterShowPopup;
		SCDOM_RESULT function(HELEMENT hePopup, POINT pos, BOOL animate) SciterShowPopupAt;
		SCDOM_RESULT function(HELEMENT he) SciterHidePopup;
		SCDOM_RESULT function( HELEMENT he, UINT* pstateBits) SciterGetElementState;
		SCDOM_RESULT function( HELEMENT he, UINT stateBitsToSet, UINT stateBitsToClear, BOOL updateView) SciterSetElementState;
		SCDOM_RESULT function( LPCSTR tagname, LPCWSTR textOrNull, /*out*/ HELEMENT *phe ) SciterCreateElement;
		SCDOM_RESULT function( HELEMENT he, /*out*/ HELEMENT *phe ) SciterCloneElement;
		SCDOM_RESULT function( HELEMENT he, HELEMENT hparent, UINT index ) SciterInsertElement;
		SCDOM_RESULT function( HELEMENT he ) SciterDetachElement;
		SCDOM_RESULT function(HELEMENT he) SciterDeleteElement;
		SCDOM_RESULT function( HELEMENT he, UINT milliseconds, UINT_PTR timer_id ) SciterSetTimer;
		SCDOM_RESULT function( HELEMENT he, LPELEMENT_EVENT_PROC pep, LPVOID tag ) SciterDetachEventHandler;
		SCDOM_RESULT function( HELEMENT he, LPELEMENT_EVENT_PROC pep, LPVOID tag ) SciterAttachEventHandler;
		SCDOM_RESULT function( HWINDOW hwndLayout, LPELEMENT_EVENT_PROC pep, LPVOID tag, UINT subscription ) SciterWindowAttachEventHandler;
		SCDOM_RESULT function( HWINDOW hwndLayout, LPELEMENT_EVENT_PROC pep, LPVOID tag ) SciterWindowDetachEventHandler;
		SCDOM_RESULT function( HELEMENT he, UINT appEventCode, HELEMENT heSource, UINT_PTR reason, /*out*/ BOOL* handled) SciterSendEvent;
		SCDOM_RESULT function( HELEMENT he, UINT appEventCode, HELEMENT heSource, UINT_PTR reason) SciterPostEvent;
		SCDOM_RESULT function(HELEMENT he, METHOD_PARAMS* params) SciterCallBehaviorMethod;
		SCDOM_RESULT function( HELEMENT he, LPCWSTR url, UINT dataType, HELEMENT initiator ) SciterRequestElementData;
		SCDOM_RESULT function( HELEMENT he,						// element to deliver data 
								LPCWSTR         url,			// url 
								UINT            dataType,		// data type, see SciterResourceType.
								UINT            requestType,	// one of REQUEST_TYPE values
								REQUEST_PARAM*  requestParams,	// parameters
								UINT            nParams			// number of parameters 
								) SciterHttpRequest;
		SCDOM_RESULT function( HELEMENT he, LPPOINT scrollPos, LPRECT viewRect, LPSIZE contentSize ) SciterGetScrollInfo;
		SCDOM_RESULT function( HELEMENT he, POINT scrollPos, BOOL smooth ) SciterSetScrollPos;
		SCDOM_RESULT function( HELEMENT he, INT* pMinWidth, INT* pMaxWidth ) SciterGetElementIntrinsicWidths;
		SCDOM_RESULT function( HELEMENT he, INT forWidth, INT* pHeight ) SciterGetElementIntrinsicHeight;
		SCDOM_RESULT function( HELEMENT he, BOOL* pVisible) SciterIsElementVisible;
		SCDOM_RESULT function( HELEMENT he, BOOL* pEnabled ) SciterIsElementEnabled;
		SCDOM_RESULT function( HELEMENT he, UINT firstIndex, UINT lastIndex, ELEMENT_COMPARATOR* cmpFunc, LPVOID cmpFuncParam ) SciterSortElements;
		SCDOM_RESULT function( HELEMENT he1, HELEMENT he2 ) SciterSwapElements;
		SCDOM_RESULT function( UINT evt, LPVOID eventCtlStruct, BOOL* bOutProcessed ) SciterTraverseUIEvent;
		SCDOM_RESULT function( HELEMENT he, LPCSTR name, const VALUE* argv, UINT argc, VALUE* retval ) SciterCallScriptingMethod;
		SCDOM_RESULT function( HELEMENT he, LPCSTR name, const VALUE* argv, UINT argc, VALUE* retval ) SciterCallScriptingFunction;
		SCDOM_RESULT function( HELEMENT he, LPCWSTR script, UINT scriptLength, VALUE* retval ) SciterEvalElementScript;
		SCDOM_RESULT function( HELEMENT he, HWINDOW hwnd) SciterAttachHwndToElement;
		SCDOM_RESULT function( HELEMENT he, /*CTL_TYPE*/ UINT *pType ) SciterControlGetType;
		SCDOM_RESULT function( HELEMENT he, VALUE* pval ) SciterGetValue;
		SCDOM_RESULT function( HELEMENT he, const VALUE* pval ) SciterSetValue;
		SCDOM_RESULT function( HELEMENT he, VALUE* pval, BOOL forceCreation ) SciterGetExpando;
		SCDOM_RESULT function( HELEMENT he, tiscript_value* pval, BOOL forceCreation ) SciterGetObject;
		SCDOM_RESULT function( HELEMENT he, tiscript_value* pval) SciterGetElementNamespace;
		SCDOM_RESULT function( HWINDOW hwnd, HELEMENT* phe) SciterGetHighlightedElement;
		SCDOM_RESULT function( HWINDOW hwnd, HELEMENT he) SciterSetHighlightedElement;
		//|
		//| DOM Node API 
		//|
		SCDOM_RESULT function(HNODE hn) SciterNodeAddRef;
		SCDOM_RESULT function(HNODE hn) SciterNodeRelease;
		SCDOM_RESULT function(HELEMENT he, HNODE* phn) SciterNodeCastFromElement;
		SCDOM_RESULT function(HNODE hn, HELEMENT* he) SciterNodeCastToElement;
		SCDOM_RESULT function(HNODE hn, HNODE* phn) SciterNodeFirstChild;
		SCDOM_RESULT function(HNODE hn, HNODE* phn) SciterNodeLastChild;
		SCDOM_RESULT function(HNODE hn, HNODE* phn) SciterNodeNextSibling;
		SCDOM_RESULT function(HNODE hn, HNODE* phn) SciterNodePrevSibling;
		SCDOM_RESULT function(HNODE hnode, HELEMENT* pheParent) SciterNodeParent;
		SCDOM_RESULT function(HNODE hnode, UINT n, HNODE* phn) SciterNodeNthChild;
		SCDOM_RESULT function(HNODE hnode, UINT* pn) SciterNodeChildrenCount;
		SCDOM_RESULT function(HNODE hnode, UINT* pNodeType /*NODE_TYPE*/) SciterNodeType;
		SCDOM_RESULT function(HNODE hnode, LPCWSTR_RECEIVER rcv, LPVOID rcv_param) SciterNodeGetText;
		SCDOM_RESULT function(HNODE hnode, LPCWSTR text, UINT textLength) SciterNodeSetText;
		SCDOM_RESULT function(HNODE hnode, UINT where /*NODE_INS_TARGET*/, HNODE what) SciterNodeInsert;
		SCDOM_RESULT function(HNODE hnode, BOOL finalize) SciterNodeRemove;
		SCDOM_RESULT function(LPCWSTR text, UINT textLength, HNODE* phnode) SciterCreateTextNode;
		SCDOM_RESULT function(LPCWSTR text, UINT textLength, HNODE* phnode) SciterCreateCommentNode;
		//|
		//| Value API 
		//|
		UINT function( VALUE* pval ) ValueInit;
		UINT function( VALUE* pval ) ValueClear;
		UINT function( const VALUE* pval1, const VALUE* pval2 ) ValueCompare;
		UINT function( VALUE* pdst, const VALUE* psrc ) ValueCopy;
		UINT function( VALUE* pdst ) ValueIsolate;
		UINT function( const VALUE* pval, UINT* pType, UINT* pUnits ) ValueType;
		UINT function( const VALUE* pval, LPCWSTR* pChars, UINT* pNumChars ) ValueStringData;
		UINT function( VALUE* pval, LPCWSTR chars, UINT numChars, UINT units ) ValueStringDataSet;
		UINT function( const VALUE* pval, INT* pData ) ValueIntData;
		UINT function( VALUE* pval, INT data, UINT type, UINT units ) ValueIntDataSet;
		UINT function( const VALUE* pval, INT64* pData ) ValueInt64Data;
		UINT function( VALUE* pval, INT64 data, UINT type, UINT units ) ValueInt64DataSet;
		UINT function( const VALUE* pval, FLOAT_VALUE* pData ) ValueFloatData;
		UINT function( VALUE* pval, FLOAT_VALUE data, UINT type, UINT units ) ValueFloatDataSet;
		UINT function( const VALUE* pval, LPCBYTE* pBytes, UINT* pnBytes ) ValueBinaryData;
		UINT function( VALUE* pval, LPCBYTE pBytes, UINT nBytes, UINT type, UINT units ) ValueBinaryDataSet;
		UINT function( const VALUE* pval, INT* pn) ValueElementsCount;
		UINT function( const VALUE* pval, INT n, VALUE* pretval) ValueNthElementValue;
		UINT function( VALUE* pval, INT n, const VALUE* pval_to_set) ValueNthElementValueSet;
		UINT function( const VALUE* pval, INT n, VALUE* pretval) ValueNthElementKey;
		UINT function( VALUE* pval, KeyValueCallback* penum, LPVOID param) ValueEnumElements;
		UINT function( VALUE* pval, const VALUE* pkey, const VALUE* pval_to_set) ValueSetValueToKey;
		UINT function( const VALUE* pval, const VALUE* pkey, VALUE* pretval) ValueGetValueOfKey;
		UINT function( VALUE* pval, /*VALUE_STRING_CVT_TYPE*/ UINT how ) ValueToString;
		UINT function( VALUE* pval, LPCWSTR str, UINT strLength, /*VALUE_STRING_CVT_TYPE*/ UINT how ) ValueFromString;
		UINT function( VALUE* pval, VALUE* pthis, UINT argc, const VALUE* argv, VALUE* pretval, LPCWSTR url) ValueInvoke;
		UINT function( VALUE* pval, NATIVE_FUNCTOR_VALUE* pnfv) ValueNativeFunctorSet;
		BOOL function( const VALUE* pval) ValueIsNativeFunctor;

		// tiscript VM API
		tiscript_native_interface* function() TIScriptAPI;
		HVM function(HWINDOW hwnd) SciterGetVM;

		BOOL function(HVM vm, tiscript_value script_value, VALUE* value, BOOL isolate) Sciter_v2V;
		BOOL function(HVM vm, const VALUE* valuev, tiscript_value* script_value) Sciter_V2v;

		HSARCHIVE function(LPCBYTE archiveData, UINT archiveDataLength) SciterOpenArchive;
		BOOL function(HSARCHIVE harc, LPCWSTR path, LPCBYTE* pdata, UINT* pdataLength) SciterGetArchiveItem;
		BOOL function(HSARCHIVE harc) SciterCloseArchive;

		SCDOM_RESULT function( const BEHAVIOR_EVENT_PARAMS* evt, BOOL post, BOOL *handled ) SciterFireEvent;

		LPVOID function(HWINDOW hwnd) SciterGetCallbackParam;
		UINT_PTR function(HWINDOW hwnd, UINT_PTR wparam, UINT_PTR lparam, UINT timeoutms) SciterPostCallback;// if timeoutms>0 then it is a send, not a post
	}
}

// added
struct NATIVE_FUNCTOR_VALUE;