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

module sciter.interop.sciter_x_api;

import sciter.interop.sciter_x_types;
import sciter.interop.sciter_x_def;
import sciter.interop.sciter_x_behaviors;
import sciter.interop.tiscript;

extern(Windows)
{
	ISciterAPI* SciterAPI();

	struct ISciterAPI
	{
		uint _version;

		LPCWSTR	function() SciterClassName;
		uint	function(BOOL major) SciterVersion;
		BOOL	function(HWINDOW hwnd, LPCWSTR uri, LPCBYTE data, uint dataLength) SciterDataReady;
		BOOL	function(HWINDOW hwnd, LPCWSTR uri, LPCBYTE data, uint dataLength, void* requestId) SciterDataReadyAsync;
	version(Windows)
	{
		LRESULT	function(HWINDOW hwnd, uint msg, WPARAM wParam, LPARAM lParam) SciterProc;
		LRESULT	function(HWINDOW hwnd, uint msg, WPARAM wParam, LPARAM lParam, BOOL* pbHandled) SciterProcND;
	}
		BOOL	function(HWINDOW hWndSciter, LPCWSTR filename) SciterLoadFile;
		BOOL    function(HWINDOW hWndSciter, LPCBYTE html, uint htmlSize, LPCWSTR baseUrl) SciterLoadHtml;
		void    function(HWINDOW hWndSciter, LPSciterHostCallback cb, void* cbParam) SciterSetCallback;
		BOOL    function(LPCBYTE utf8, uint numBytes) SciterSetMasterCSS;
		BOOL    function(LPCBYTE utf8, uint numBytes) SciterAppendMasterCSS;
		BOOL    function(HWINDOW hWndSciter, LPCBYTE utf8, uint numBytes, LPCWSTR baseUrl, LPCWSTR mediaType) SciterSetCSS;
		BOOL    function(HWINDOW hWndSciter, LPCWSTR mediaType) SciterSetMediaType;
		BOOL    function(HWINDOW hWndSciter, const VALUE* mediaVars) SciterSetMediaVars;
		uint    function(HWINDOW hWndSciter) SciterGetMinWidth;
		uint    function(HWINDOW hWndSciter, uint width) SciterGetMinHeight;
		BOOL    function(HWINDOW hWnd, LPCSTR functionName, uint argc, const VALUE* argv, VALUE* retval) SciterCall;
		BOOL    function(HWINDOW hwnd, LPCWSTR script, uint scriptLength, VALUE* pretval) SciterEval;
		void    function(HWINDOW hwnd) SciterUpdateWindow;
	version(Windows)
		BOOL	function(MSG* lpMsg) SciterTranslateMessage;
		BOOL    function(HWINDOW hWnd, uint option, UINT_PTR value ) SciterSetOption;
		void    function(HWINDOW hWndSciter, uint* px, uint* py) SciterGetPPI;
		BOOL    function(HWINDOW hwnd, VALUE* pval ) SciterGetViewExpando;
	version(Windows)
	{
		BOOL	 function(HWINDOW hWndSciter, ID2D1RenderTarget* prt) SciterRenderD2D;
		BOOL	 function(ID2D1Factory ** ppf) SciterD2DFactory;
		BOOL	 function(IDWriteFactory ** ppf) SciterDWFactory;
	}
		BOOL    function(uint* pcaps) SciterGraphicsCaps;
		BOOL    function(HWINDOW hWndSciter, LPCWSTR baseUrl) SciterSetHomeURL;
	version(OSX)
		HWINDOW function( LPRECT frame ) SciterCreateNSView;// returns NSView*
		HWINDOW	function(uint creationFlags, RECT* frame, SciterWindowDelegate delegt, void* delegateParam, HWINDOW parent) SciterCreateWindow;
		void	function(
						HWINDOW               hwndOrNull,// HWINDOW or null if this is global output handler
						void*                 param,     // param to be passed "as is" to the pfOutput
						DEBUG_OUTPUT_PROC     pfOutput   // output function, output stream alike thing.
						) SciterSetupDebugOutput;

		//|
		//| DOM Element API 
		//|
		SCDOM_RESULT function(HELEMENT he) Sciter_UseElement;
		SCDOM_RESULT function(HELEMENT he) Sciter_UnuseElement;
		SCDOM_RESULT function(HWINDOW hwnd, HELEMENT *phe) SciterGetRootElement;
		SCDOM_RESULT function(HWINDOW hwnd, HELEMENT *phe) SciterGetFocusElement;
		SCDOM_RESULT function(HWINDOW hwnd, POINT pt, HELEMENT* phe) SciterFindElement;
		SCDOM_RESULT function(HELEMENT he, uint* count) SciterGetChildrenCount;
		SCDOM_RESULT function(HELEMENT he, uint n, HELEMENT* phe) SciterGetNthChild;
		SCDOM_RESULT function(HELEMENT he, HELEMENT* p_parent_he) SciterGetParentElement;
		SCDOM_RESULT function(HELEMENT he, BOOL outer, LPCBYTE_RECEIVER rcv, void* rcv_param) SciterGetElementHtmlCB;
		SCDOM_RESULT function(HELEMENT he, LPCWSTR_RECEIVER rcv, void* rcv_param) SciterGetElementTextCB;
		SCDOM_RESULT function(HELEMENT he, LPCWSTR utf16, uint length) SciterSetElementText;
		SCDOM_RESULT function(HELEMENT he, uint* p_count) SciterGetAttributeCount;
		SCDOM_RESULT function(HELEMENT he, uint n, LPCSTR_RECEIVER rcv, void* rcv_param) SciterGetNthAttributeNameCB;
		SCDOM_RESULT function(HELEMENT he, uint n, LPCWSTR_RECEIVER rcv, void* rcv_param) SciterGetNthAttributeValueCB;
		SCDOM_RESULT function(HELEMENT he, LPCSTR name, LPCWSTR_RECEIVER rcv, void* rcv_param) SciterGetAttributeByNameCB;
		SCDOM_RESULT function(HELEMENT he, LPCSTR name, LPCWSTR value) SciterSetAttributeByName;
		SCDOM_RESULT function(HELEMENT he) SciterClearAttributes;
		SCDOM_RESULT function(HELEMENT he, uint* p_index) SciterGetElementIndex;
		SCDOM_RESULT function(HELEMENT he, LPCSTR* p_type) SciterGetElementType;
		SCDOM_RESULT function(HELEMENT he, LPCSTR_RECEIVER rcv, void* rcv_param) SciterGetElementTypeCB;
		SCDOM_RESULT function(HELEMENT he, LPCSTR name, LPCWSTR_RECEIVER rcv, void* rcv_param) SciterGetStyleAttributeCB;
		SCDOM_RESULT function(HELEMENT he, LPCSTR name, LPCWSTR value) SciterSetStyleAttribute;
		SCDOM_RESULT function(HELEMENT he, RECT* p_location, uint areas /*ELEMENT_AREAS*/) SciterGetElementLocation;
		SCDOM_RESULT function(HELEMENT he, uint SciterScrollFlags) SciterScrollToView;
		SCDOM_RESULT function(HELEMENT he, BOOL andForceRender) SciterUpdateElement;
		SCDOM_RESULT function(HELEMENT he, RECT rc) SciterRefreshElementArea;
		SCDOM_RESULT function(HELEMENT he) SciterSetCapture;
		SCDOM_RESULT function(HELEMENT he) SciterReleaseCapture;
		SCDOM_RESULT function(HELEMENT he, HWINDOW* p_hwnd, BOOL rootWindow) SciterGetElementHwnd;
		SCDOM_RESULT function(HELEMENT he, LPWSTR szUrlBuffer, uint UrlBufferSize) SciterCombineURL;
		SCDOM_RESULT function(HELEMENT  he, LPCSTR    CSS_selectors, SciterElementCallback callback, void* param) SciterSelectElements;
		SCDOM_RESULT function(HELEMENT  he, LPCWSTR   CSS_selectors, SciterElementCallback callback, void* param) SciterSelectElementsW;
		SCDOM_RESULT function(HELEMENT  he, LPCSTR    selector, uint      depth, HELEMENT* heFound) SciterSelectParent;
		SCDOM_RESULT function(HELEMENT  he, LPCWSTR   selector, uint      depth, HELEMENT* heFound) SciterSelectParentW;
		SCDOM_RESULT function(HELEMENT he, const BYTE* html, uint htmlLength, uint where) SciterSetElementHtml;
		SCDOM_RESULT function(HELEMENT he, uint* puid) SciterGetElementUID;
		SCDOM_RESULT function(HWINDOW hwnd, uint uid, HELEMENT* phe) SciterGetElementByUID;
		SCDOM_RESULT function(HELEMENT hePopup, HELEMENT heAnchor, uint placement) SciterShowPopup;
		SCDOM_RESULT function(HELEMENT hePopup, POINT pos, BOOL animate) SciterShowPopupAt;
		SCDOM_RESULT function(HELEMENT he) SciterHidePopup;
		SCDOM_RESULT function( HELEMENT he, uint* pstateBits) SciterGetElementState;
		SCDOM_RESULT function( HELEMENT he, uint stateBitsToSet, uint stateBitsToClear, BOOL updateView) SciterSetElementState;
		SCDOM_RESULT function( LPCSTR tagname, LPCWSTR textOrNull, /*out*/ HELEMENT *phe ) SciterCreateElement;
		SCDOM_RESULT function( HELEMENT he, /*out*/ HELEMENT *phe ) SciterCloneElement;
		SCDOM_RESULT function( HELEMENT he, HELEMENT hparent, uint index ) SciterInsertElement;
		SCDOM_RESULT function( HELEMENT he ) SciterDetachElement;
		SCDOM_RESULT function(HELEMENT he) SciterDeleteElement;
		SCDOM_RESULT function( HELEMENT he, uint milliseconds, UINT_PTR timer_id ) SciterSetTimer;
		SCDOM_RESULT function( HELEMENT he, LPELEMENT_EVENT_PROC pep, void* tag ) SciterDetachEventHandler;
		SCDOM_RESULT function( HELEMENT he, LPELEMENT_EVENT_PROC pep, void* tag ) SciterAttachEventHandler;
		SCDOM_RESULT function( HWINDOW hwndLayout, LPELEMENT_EVENT_PROC pep, void* tag, uint subscription ) SciterWindowAttachEventHandler;
		SCDOM_RESULT function( HWINDOW hwndLayout, LPELEMENT_EVENT_PROC pep, void* tag ) SciterWindowDetachEventHandler;
		SCDOM_RESULT function( HELEMENT he, uint appEventCode, HELEMENT heSource, UINT_PTR reason, /*out*/ BOOL* handled) SciterSendEvent;
		SCDOM_RESULT function( HELEMENT he, uint appEventCode, HELEMENT heSource, UINT_PTR reason) SciterPostEvent;
		SCDOM_RESULT function(HELEMENT he, METHOD_PARAMS* params) SciterCallBehaviorMethod;
		SCDOM_RESULT function( HELEMENT he, LPCWSTR url, uint dataType, HELEMENT initiator ) SciterRequestElementData;
		SCDOM_RESULT function( HELEMENT he,						// element to deliver data 
								LPCWSTR         url,			// url 
								uint            dataType,		// data type, see SciterResourceType.
								uint            requestType,	// one of REQUEST_TYPE values
								REQUEST_PARAM*  requestParams,	// parameters
								uint            nParams			// number of parameters 
								) SciterHttpRequest;
		SCDOM_RESULT function( HELEMENT he, POINT* scrollPos, RECT* viewRect, SIZE* contentSize ) SciterGetScrollInfo;
		SCDOM_RESULT function( HELEMENT he, POINT scrollPos, BOOL smooth ) SciterSetScrollPos;
		SCDOM_RESULT function( HELEMENT he, int* pMinWidth, int* pMaxWidth ) SciterGetElementIntrinsicWidths;
		SCDOM_RESULT function( HELEMENT he, int forWidth, int* pHeight ) SciterGetElementIntrinsicHeight;
		SCDOM_RESULT function( HELEMENT he, BOOL* pVisible) SciterIsElementVisible;
		SCDOM_RESULT function( HELEMENT he, BOOL* pEnabled ) SciterIsElementEnabled;
		SCDOM_RESULT function( HELEMENT he, uint firstIndex, uint lastIndex, ELEMENT_COMPARATOR* cmpFunc, void* cmpFuncParam ) SciterSortElements;
		SCDOM_RESULT function( HELEMENT he1, HELEMENT he2 ) SciterSwapElements;
		SCDOM_RESULT function( uint evt, void* eventCtlStruct, BOOL* bOutProcessed ) SciterTraverseUIEvent;
		SCDOM_RESULT function( HELEMENT he, LPCSTR name, const VALUE* argv, uint argc, VALUE* retval ) SciterCallScriptingMethod;
		SCDOM_RESULT function( HELEMENT he, LPCSTR name, const VALUE* argv, uint argc, VALUE* retval ) SciterCallScriptingFunction;
		SCDOM_RESULT function( HELEMENT he, LPCWSTR script, uint scriptLength, VALUE* retval ) SciterEvalElementScript;
		SCDOM_RESULT function( HELEMENT he, HWINDOW hwnd) SciterAttachHwndToElement;
		SCDOM_RESULT function( HELEMENT he, /*CTL_TYPE*/ uint *pType ) SciterControlGetType;
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
		SCDOM_RESULT function(HNODE hnode, uint n, HNODE* phn) SciterNodeNthChild;
		SCDOM_RESULT function(HNODE hnode, uint* pn) SciterNodeChildrenCount;
		SCDOM_RESULT function(HNODE hnode, uint* pNodeType /*NODE_TYPE*/) SciterNodeType;
		SCDOM_RESULT function(HNODE hnode, LPCWSTR_RECEIVER rcv, void* rcv_param) SciterNodeGetText;
		SCDOM_RESULT function(HNODE hnode, LPCWSTR text, uint textLength) SciterNodeSetText;
		SCDOM_RESULT function(HNODE hnode, uint where /*NODE_INS_TARGET*/, HNODE what) SciterNodeInsert;
		SCDOM_RESULT function(HNODE hnode, BOOL finalize) SciterNodeRemove;
		SCDOM_RESULT function(LPCWSTR text, uint textLength, HNODE* phnode) SciterCreateTextNode;
		SCDOM_RESULT function(LPCWSTR text, uint textLength, HNODE* phnode) SciterCreateCommentNode;
		//|
		//| Value API 
		//|
		uint function( VALUE* pval ) ValueInit;
		uint function( VALUE* pval ) ValueClear;
		uint function( const VALUE* pval1, const VALUE* pval2 ) ValueCompare;
		uint function( VALUE* pdst, const VALUE* psrc ) ValueCopy;
		uint function( VALUE* pdst ) ValueIsolate;
		uint function( const VALUE* pval, uint* pType, uint* pUnits ) ValueType;
		uint function( const VALUE* pval, LPCWSTR* pChars, uint* pNumChars ) ValueStringData;
		uint function( VALUE* pval, LPCWSTR chars, uint numChars, uint units ) ValueStringDataSet;
		uint function( const VALUE* pval, int* pData ) ValueIntData;
		uint function( VALUE* pval, int data, uint type, uint units ) ValueIntDataSet;
		uint function( const VALUE* pval, long* pData ) ValueInt64Data;
		uint function( VALUE* pval, long data, uint type, uint units ) ValueInt64DataSet;
		uint function( const VALUE* pval, FLOAT_VALUE* pData ) ValueFloatData;
		uint function( VALUE* pval, FLOAT_VALUE data, uint type, uint units ) ValueFloatDataSet;
		uint function( const VALUE* pval, LPCBYTE* pBytes, uint* pnBytes ) ValueBinaryData;
		uint function( VALUE* pval, LPCBYTE pBytes, uint nBytes, uint type, uint units ) ValueBinaryDataSet;
		uint function( const VALUE* pval, int* pn) ValueElementsCount;
		uint function( const VALUE* pval, int n, VALUE* pretval) ValueNthElementValue;
		uint function( VALUE* pval, int n, const VALUE* pval_to_set) ValueNthElementValueSet;
		uint function( const VALUE* pval, int n, VALUE* pretval) ValueNthElementKey;
		uint function( VALUE* pval, KeyValueCallback* penum, void* param) ValueEnumElements;
		uint function( VALUE* pval, const VALUE* pkey, const VALUE* pval_to_set) ValueSetValueToKey;
		uint function( const VALUE* pval, const VALUE* pkey, VALUE* pretval) ValueGetValueOfKey;
		uint function( VALUE* pval, /*VALUE_STRING_CVT_TYPE*/ uint how ) ValueToString;
		uint function( VALUE* pval, LPCWSTR str, uint strLength, /*VALUE_STRING_CVT_TYPE*/ uint how ) ValueFromString;
		uint function( const VALUE* pval, const VALUE* pthis, uint argc, const VALUE* argv, VALUE* pretval, LPCWSTR url) ValueInvoke;
		uint function( VALUE* pval, NATIVE_FUNCTOR_INVOKE*  pinvoke, NATIVE_FUNCTOR_RELEASE* prelease, void* tag) ValueNativeFunctorSet;
		BOOL function( const VALUE* pval) ValueIsNativeFunctor;

		// tiscript VM API
		tiscript_native_interface* function() TIScriptAPI;
		HVM function(HWINDOW hwnd) SciterGetVM;

		BOOL function(HVM vm, tiscript_value script_value, VALUE* value, BOOL isolate) Sciter_v2V;
		BOOL function(HVM vm, const VALUE* valuev, tiscript_value* script_value) Sciter_V2v;

		HSARCHIVE function(LPCBYTE archiveData, uint archiveDataLength) SciterOpenArchive;
		BOOL function(HSARCHIVE harc, LPCWSTR path, LPCBYTE* pdata, uint* pdataLength) SciterGetArchiveItem;
		BOOL function(HSARCHIVE harc) SciterCloseArchive;

		SCDOM_RESULT function( const BEHAVIOR_EVENT_PARAMS* evt, BOOL post, BOOL *handled ) SciterFireEvent;

		void* function(HWINDOW hwnd) SciterGetCallbackParam;
		UINT_PTR function(HWINDOW hwnd, UINT_PTR wparam, UINT_PTR lparam, uint timeoutms) SciterPostCallback;// if timeoutms>0 then it is a send, not a post

		void* function() GetSciterGraphicsAPI;
	}
}

// added
struct NATIVE_FUNCTOR_VALUE;