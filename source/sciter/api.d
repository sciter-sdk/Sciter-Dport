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

module sciter.api;

/*version(Win64)
{
	pragma(lib, r"sciter64-import-lib.lib");
} else {
	pragma(lib, r"sciter32-import-lib.lib");
}*/

public import sciter.interop.sciter_x;
public import sciter.types;
import sciter.interop.sciter_x_types;
import sciter.interop.sciter_x_behaviors;
import sciter.interop.tiscript;


unittest
{
	// from time to time, Sciter changes its ABI; here we test the minimum Sciter version this library is compatible with
	uint major = SciterVersion(true);
	uint minor = SciterVersion(false);
	assert(major==0x00030003);
	assert(minor>=0x00000006);
	assert(SAPI()._version==0);
}



__gshared ISciterAPI* _SAPI;

shared static this()
{
	version(Windows)
	{
		_SAPI = SciterAPI();
	}
	version(linux)
	{
		import core.sys.posix.dlfcn;
		import core.stdc.stdio;
		import core.stdc.stdlib;

		void* lib_sciter_handle = dlopen("./sciter-gtk-64.so", RTLD_LOCAL|RTLD_LAZY);// there is not 32bits .so version in the SDK
		if(!lib_sciter_handle)
		{
			fprintf(stderr, "dlopen error: %s\n", dlerror());
			exit(1);
		}
		
		ISciterAPI* function() sapi = cast(ISciterAPI* function()) dlsym(lib_sciter_handle, "SciterAPI");
		char* error = dlerror();
		if(error)
		{
			fprintf(stderr, "dlsym error: %s\n", error);
			exit(1);
		}

		_SAPI = sapi();
	}
}

ISciterAPI* SAPI()
{
	return _SAPI;
}



// defining "official" API functions:
LPCWSTR SciterClassName () { return SAPI().SciterClassName(); }
uint    SciterVersion (BOOL major) { return SAPI().SciterVersion (major); }
BOOL    SciterDataReady (HWINDOW hwnd,LPCWSTR uri,LPCBYTE data, uint dataLength) { return SAPI().SciterDataReady (hwnd,uri,data,dataLength); }
BOOL    SciterDataReadyAsync (HWINDOW hwnd,LPCWSTR uri, LPCBYTE data, uint dataLength, void* requestId) { return SAPI().SciterDataReadyAsync (hwnd,uri, data, dataLength, requestId); }
version(Windows)
{
	LRESULT SciterProc (HWINDOW hwnd, uint msg, WPARAM wParam, LPARAM lParam) { return SAPI().SciterProc (hwnd,msg,wParam,lParam); }
	LRESULT SciterProcND (HWINDOW hwnd, uint msg, WPARAM wParam, LPARAM lParam, BOOL* pbHandled) { return SAPI().SciterProcND (hwnd,msg,wParam,lParam,pbHandled); }
}
BOOL    SciterLoadFile (HWINDOW hWndSciter, LPCWSTR filename) { return SAPI().SciterLoadFile (hWndSciter,filename); }
BOOL    SciterLoadHtml (HWINDOW hWndSciter, LPCBYTE html, uint htmlSize, LPCWSTR baseUrl) { return SAPI().SciterLoadHtml (hWndSciter,html,htmlSize,baseUrl); }
void    SciterSetCallback (HWINDOW hWndSciter, LPSciterHostCallback cb, void* cbParam) { SAPI().SciterSetCallback (hWndSciter,cb,cbParam); }
BOOL    SciterSetMasterCSS (LPCBYTE utf8, uint numBytes) { return SAPI().SciterSetMasterCSS (utf8,numBytes); }
BOOL    SciterAppendMasterCSS (LPCBYTE utf8, uint numBytes) { return SAPI().SciterAppendMasterCSS (utf8,numBytes); }
BOOL    SciterSetCSS (HWINDOW hWndSciter, LPCBYTE utf8, uint numBytes, LPCWSTR baseUrl, LPCWSTR mediaType) { return SAPI().SciterSetCSS (hWndSciter,utf8,numBytes,baseUrl,mediaType); }
BOOL    SciterSetMediaType (HWINDOW hWndSciter, LPCWSTR mediaType) { return SAPI().SciterSetMediaType (hWndSciter,mediaType); }
BOOL    SciterSetMediaVars (HWINDOW hWndSciter, const VALUE *mediaVars) { return SAPI().SciterSetMediaVars (hWndSciter,mediaVars); }
uint    SciterGetMinWidth (HWINDOW hWndSciter) { return SAPI().SciterGetMinWidth (hWndSciter); }
uint    SciterGetMinHeight (HWINDOW hWndSciter, uint width) { return SAPI().SciterGetMinHeight (hWndSciter,width); }
BOOL    SciterCall (HWINDOW hWnd, LPCSTR functionName, uint argc, const VALUE* argv, VALUE* retval) { return SAPI().SciterCall (hWnd,functionName, argc,argv,retval); }
BOOL    SciterEval (HWINDOW hwnd, LPCWSTR script, uint scriptLength, VALUE* pretval) { return SAPI().SciterEval ( hwnd, script, scriptLength, pretval); }
void    SciterUpdateWindow(HWINDOW hwnd) { SAPI().SciterUpdateWindow(hwnd); }
version(Windows)
{
	BOOL    SciterTranslateMessage (MSG* lpMsg) { return SAPI().SciterTranslateMessage (lpMsg); }
}
BOOL    SciterSetOption (HWINDOW hWnd, SCITER_RT_OPTIONS option, UINT_PTR value ) { return SAPI().SciterSetOption (hWnd,option,value ); }
void    SciterGetPPI (HWINDOW hWndSciter, uint* px, uint* py) { SAPI().SciterGetPPI (hWndSciter,px,py); }
BOOL    SciterGetViewExpando ( HWINDOW hwnd, VALUE* pval ) { return SAPI().SciterGetViewExpando ( hwnd, pval ); }
version(Windows)
{
	BOOL    SciterRenderD2D (HWINDOW hWndSciter, ID2D1RenderTarget* prt) { return SAPI().SciterRenderD2D (hWndSciter,prt); }
	BOOL    SciterD2DFactory (ID2D1Factory ** ppf) { return SAPI().SciterD2DFactory (ppf); }
	BOOL    SciterDWFactory (IDWriteFactory ** ppf) { return SAPI().SciterDWFactory (ppf); }
}
BOOL    SciterGraphicsCaps (uint* pcaps) { return SAPI().SciterGraphicsCaps (pcaps); }
BOOL    SciterSetHomeURL (HWINDOW hWndSciter, LPCWSTR baseUrl) { return SAPI().SciterSetHomeURL (hWndSciter,baseUrl); }
version(OSX)
{
	HWINDOW	SciterCreateNSView ( LPRECT frame ) { return SAPI().SciterCreateNSView ( frame ); }
}
HWINDOW SciterCreateWindow( uint creationFlags /*SCITER_CREATE_WINDOW_FLAGS*/, RECT* frame = null, SciterWindowDelegate delegate_ = null, void* delegateParam = null, HWINDOW parent = null) { return SAPI().SciterCreateWindow (creationFlags, frame, delegate_, delegateParam, parent); }

SCDOM_RESULT Sciter_UseElement(HELEMENT he) { return SAPI().Sciter_UseElement(he); }
SCDOM_RESULT Sciter_UnuseElement(HELEMENT he) { return SAPI().Sciter_UnuseElement(he); }
SCDOM_RESULT SciterGetRootElement(HWINDOW hwnd, HELEMENT *phe) { return SAPI().SciterGetRootElement(hwnd, phe); }
SCDOM_RESULT SciterGetFocusElement(HWINDOW hwnd, HELEMENT *phe) { return SAPI().SciterGetFocusElement(hwnd, phe); }
SCDOM_RESULT SciterFindElement(HWINDOW hwnd, POINT pt, HELEMENT* phe) { return SAPI().SciterFindElement(hwnd,pt,phe); }
SCDOM_RESULT SciterGetChildrenCount(HELEMENT he, uint* count) { return SAPI().SciterGetChildrenCount(he, count); }
SCDOM_RESULT SciterGetNthChild(HELEMENT he, uint n, HELEMENT* phe) { return SAPI().SciterGetNthChild(he,n,phe); }
SCDOM_RESULT SciterGetParentElement(HELEMENT he, HELEMENT* p_parent_he) { return SAPI().SciterGetParentElement(he,p_parent_he); }
SCDOM_RESULT SciterGetElementHtmlCB(HELEMENT he, BOOL outer, LPCBYTE_RECEIVER rcv, void* rcv_param) { return SAPI().SciterGetElementHtmlCB( he, outer, rcv, rcv_param); }
SCDOM_RESULT SciterGetElementTextCB(HELEMENT he, LPCWSTR_RECEIVER rcv, void* rcv_param) { return SAPI().SciterGetElementTextCB(he, rcv, rcv_param); }
SCDOM_RESULT SciterSetElementText(HELEMENT he, LPCWSTR utf16, uint length) { return SAPI().SciterSetElementText(he, utf16, length); }
SCDOM_RESULT SciterGetAttributeCount(HELEMENT he, uint* p_count) { return SAPI().SciterGetAttributeCount(he, p_count); }
SCDOM_RESULT SciterGetNthAttributeNameCB(HELEMENT he, uint n, LPCSTR_RECEIVER rcv, void* rcv_param) { return SAPI().SciterGetNthAttributeNameCB(he,n,rcv,rcv_param); }
SCDOM_RESULT SciterGetNthAttributeValueCB(HELEMENT he, uint n, LPCWSTR_RECEIVER rcv, void* rcv_param) { return SAPI().SciterGetNthAttributeValueCB(he, n, rcv, rcv_param); }
SCDOM_RESULT SciterGetAttributeByNameCB(HELEMENT he, LPCSTR name, LPCWSTR_RECEIVER rcv, void* rcv_param) { return SAPI().SciterGetAttributeByNameCB(he,name,rcv,rcv_param); }
SCDOM_RESULT SciterSetAttributeByName(HELEMENT he, LPCSTR name, LPCWSTR value) { return SAPI().SciterSetAttributeByName(he,name,value); }
SCDOM_RESULT SciterClearAttributes(HELEMENT he) { return SAPI().SciterClearAttributes(he); }
SCDOM_RESULT SciterGetElementIndex(HELEMENT he, uint* p_index) { return SAPI().SciterGetElementIndex(he,p_index); }
SCDOM_RESULT SciterGetElementType(HELEMENT he, LPCSTR* p_type) { return SAPI().SciterGetElementType(he,p_type); }
SCDOM_RESULT SciterGetElementTypeCB(HELEMENT he, LPCSTR_RECEIVER rcv, void* rcv_param) { return SAPI().SciterGetElementTypeCB(he,rcv,rcv_param); }
SCDOM_RESULT SciterGetStyleAttributeCB(HELEMENT he, LPCSTR name, LPCWSTR_RECEIVER rcv, void* rcv_param) { return SAPI().SciterGetStyleAttributeCB(he,name,rcv,rcv_param); }
SCDOM_RESULT SciterSetStyleAttribute(HELEMENT he, LPCSTR name, LPCWSTR value) { return SAPI().SciterSetStyleAttribute(he,name,value); }
SCDOM_RESULT SciterGetElementLocation(HELEMENT he, RECT* p_location, uint areas /*ELEMENT_AREAS*/) { return SAPI().SciterGetElementLocation(he,p_location,areas); }
SCDOM_RESULT SciterScrollToView(HELEMENT he, uint SciterScrollFlags) { return SAPI().SciterScrollToView(he,SciterScrollFlags); }
SCDOM_RESULT SciterUpdateElement(HELEMENT he, BOOL andForceRender) { return SAPI().SciterUpdateElement(he,andForceRender); }
SCDOM_RESULT SciterRefreshElementArea(HELEMENT he, RECT rc) { return SAPI().SciterRefreshElementArea(he,rc); }
SCDOM_RESULT SciterSetCapture(HELEMENT he) { return SAPI().SciterSetCapture(he); }
SCDOM_RESULT SciterReleaseCapture(HELEMENT he) { return SAPI().SciterReleaseCapture(he); }
SCDOM_RESULT SciterGetElementHwnd(HELEMENT he, HWINDOW* p_hwnd, BOOL rootWindow) { return SAPI().SciterGetElementHwnd(he,p_hwnd,rootWindow); }
SCDOM_RESULT SciterCombineURL(HELEMENT he, LPWSTR szUrlBuffer, uint UrlBufferSize) { return SAPI().SciterCombineURL(he,szUrlBuffer,UrlBufferSize); }
SCDOM_RESULT SciterSelectElements(HELEMENT  he, LPCSTR    CSS_selectors, SciterElementCallback callback, void* param) { return SAPI().SciterSelectElements(he,CSS_selectors,callback,param); }
SCDOM_RESULT SciterSelectElementsW(HELEMENT  he, LPCWSTR   CSS_selectors, SciterElementCallback callback, void* param) { return SAPI().SciterSelectElementsW(he,CSS_selectors,callback,param); }
SCDOM_RESULT SciterSelectParent(HELEMENT  he, LPCSTR    selector, uint      depth, HELEMENT* heFound) { return SAPI().SciterSelectParent(he,selector,depth,heFound); }
SCDOM_RESULT SciterSelectParentW(HELEMENT  he, LPCWSTR   selector, uint      depth, HELEMENT* heFound) { return SAPI().SciterSelectParentW(he,selector,depth,heFound); }
SCDOM_RESULT SciterSetElementHtml(HELEMENT he, const BYTE* html, uint htmlLength, uint where) { return SAPI().SciterSetElementHtml(he,html,htmlLength,where); }
SCDOM_RESULT SciterGetElementUID(HELEMENT he, uint* puid) { return SAPI().SciterGetElementUID(he,puid); }
SCDOM_RESULT SciterGetElementByUID(HWINDOW hwnd, uint uid, HELEMENT* phe) { return SAPI().SciterGetElementByUID(hwnd,uid,phe); }
SCDOM_RESULT SciterShowPopup(HELEMENT hePopup, HELEMENT heAnchor, uint placement) { return SAPI().SciterShowPopup(hePopup,heAnchor,placement); }
SCDOM_RESULT SciterShowPopupAt(HELEMENT hePopup, POINT pos, BOOL animate) { return SAPI().SciterShowPopupAt(hePopup,pos,animate); }
SCDOM_RESULT SciterHidePopup(HELEMENT he) { return SAPI().SciterHidePopup(he); }
SCDOM_RESULT SciterGetElementState( HELEMENT he, uint* pstateBits) { return SAPI().SciterGetElementState(he,pstateBits); }
SCDOM_RESULT SciterSetElementState( HELEMENT he, uint stateBitsToSet, uint stateBitsToClear, BOOL updateView) { return SAPI().SciterSetElementState(he,stateBitsToSet,stateBitsToClear,updateView); }
SCDOM_RESULT SciterCreateElement( LPCSTR tagname, LPCWSTR textOrNull, /*out*/ HELEMENT *phe ) { return SAPI().SciterCreateElement(tagname,textOrNull,phe ); }
SCDOM_RESULT SciterCloneElement( HELEMENT he, /*out*/ HELEMENT *phe ) { return SAPI().SciterCloneElement(he,phe ); }
SCDOM_RESULT SciterInsertElement( HELEMENT he, HELEMENT hparent, uint index ) { return SAPI().SciterInsertElement(he,hparent,index ); }
SCDOM_RESULT SciterDetachElement( HELEMENT he ) { return SAPI().SciterDetachElement( he ); }
SCDOM_RESULT SciterDeleteElement(HELEMENT he) { return SAPI().SciterDeleteElement(he); }
SCDOM_RESULT SciterSetTimer( HELEMENT he, uint milliseconds, UINT_PTR timer_id ) { return SAPI().SciterSetTimer(he,milliseconds,timer_id ); }
SCDOM_RESULT SciterDetachEventHandler( HELEMENT he, LPELEMENT_EVENT_PROC pep, void* tag ) { return SAPI().SciterDetachEventHandler(he,pep,tag ); }
SCDOM_RESULT SciterAttachEventHandler( HELEMENT he, LPELEMENT_EVENT_PROC pep, void* tag ) { return SAPI().SciterAttachEventHandler( he,pep,tag ); }
SCDOM_RESULT SciterWindowAttachEventHandler( HWINDOW hwndLayout, LPELEMENT_EVENT_PROC pep, void* tag, uint subscription ) { return SAPI().SciterWindowAttachEventHandler(hwndLayout,pep,tag,subscription ); }
SCDOM_RESULT SciterWindowDetachEventHandler( HWINDOW hwndLayout, LPELEMENT_EVENT_PROC pep, void* tag ) { return SAPI().SciterWindowDetachEventHandler(hwndLayout,pep,tag ); }
SCDOM_RESULT SciterSendEvent( HELEMENT he, uint appEventCode, HELEMENT heSource, uint reason, /*out*/ BOOL* handled) { return SAPI().SciterSendEvent( he,appEventCode,heSource,reason,handled); }
SCDOM_RESULT SciterPostEvent( HELEMENT he, uint appEventCode, HELEMENT heSource, uint reason) { return SAPI().SciterPostEvent(he,appEventCode,heSource,reason); }
SCDOM_RESULT SciterFireEvent( const BEHAVIOR_EVENT_PARAMS* evt, BOOL post, BOOL *handled) { return SAPI().SciterFireEvent( evt, post, handled ); }
SCDOM_RESULT SciterCallBehaviorMethod(HELEMENT he, METHOD_PARAMS* params) { return SAPI().SciterCallBehaviorMethod(he,params); }
SCDOM_RESULT SciterRequestElementData( HELEMENT he, LPCWSTR url, uint dataType, HELEMENT initiator ) { return SAPI().SciterRequestElementData(he,url,dataType,initiator ); }
SCDOM_RESULT SciterHttpRequest( HELEMENT he, LPCWSTR url, uint dataType, uint requestType, REQUEST_PARAM* requestParams, uint nParams) { return SAPI().SciterHttpRequest(he,url,dataType,requestType,requestParams,nParams); }
SCDOM_RESULT SciterGetScrollInfo( HELEMENT he, POINT* scrollPos, RECT* viewRect, SIZE* contentSize ) { return SAPI().SciterGetScrollInfo( he,scrollPos,viewRect,contentSize ); }
SCDOM_RESULT SciterSetScrollPos( HELEMENT he, POINT scrollPos, BOOL smooth ) { return SAPI().SciterSetScrollPos( he,scrollPos,smooth ); }
SCDOM_RESULT SciterGetElementIntrinsicWidths( HELEMENT he, int* pMinWidth, int* pMaxWidth ) { return SAPI().SciterGetElementIntrinsicWidths(he,pMinWidth,pMaxWidth ); }
SCDOM_RESULT SciterGetElementIntrinsicHeight( HELEMENT he, int forWidth, int* pHeight ) { return SAPI().SciterGetElementIntrinsicHeight( he,forWidth,pHeight ); }
SCDOM_RESULT SciterIsElementVisible( HELEMENT he, BOOL* pVisible) { return SAPI().SciterIsElementVisible( he,pVisible); }
SCDOM_RESULT SciterIsElementEnabled( HELEMENT he, BOOL* pEnabled ) { return SAPI().SciterIsElementEnabled( he, pEnabled ); }
SCDOM_RESULT SciterSortElements( HELEMENT he, uint firstIndex, uint lastIndex, ELEMENT_COMPARATOR* cmpFunc, void* cmpFuncParam ) { return SAPI().SciterSortElements( he, firstIndex, lastIndex, cmpFunc, cmpFuncParam ); }
SCDOM_RESULT SciterSwapElements( HELEMENT he1, HELEMENT he2 ) { return SAPI().SciterSwapElements( he1,he2 ); }
SCDOM_RESULT SciterTraverseUIEvent( uint evt, void* eventCtlStruct, BOOL* bOutProcessed ) { return SAPI().SciterTraverseUIEvent( evt,eventCtlStruct,bOutProcessed ); }
SCDOM_RESULT SciterCallScriptingMethod( HELEMENT he, LPCSTR name, const VALUE* argv, uint argc, VALUE* retval ) { return SAPI().SciterCallScriptingMethod( he,name,argv,argc,retval ); }
SCDOM_RESULT SciterCallScriptingFunction( HELEMENT he, LPCSTR name, const VALUE* argv, uint argc, VALUE* retval ) { return SAPI().SciterCallScriptingFunction( he,name,argv,argc,retval ); }
SCDOM_RESULT SciterEvalElementScript( HELEMENT he, LPCWSTR script, uint scriptLength, VALUE* retval ) { return SAPI().SciterEvalElementScript( he, script, scriptLength, retval ); }
SCDOM_RESULT SciterAttachHwndToElement(HELEMENT he, HWINDOW hwnd) { return SAPI().SciterAttachHwndToElement(he,hwnd); }
SCDOM_RESULT SciterControlGetType( HELEMENT he, /*CTL_TYPE*/ uint *pType ) { return SAPI().SciterControlGetType( he, pType ); }
SCDOM_RESULT SciterGetValue( HELEMENT he, VALUE* pval ) { return SAPI().SciterGetValue( he,pval ); }
SCDOM_RESULT SciterSetValue( HELEMENT he, const VALUE* pval ) { return SAPI().SciterSetValue( he, pval ); }
SCDOM_RESULT SciterGetExpando( HELEMENT he, VALUE* pval, BOOL forceCreation ) { return SAPI().SciterGetExpando( he, pval, forceCreation ); }
SCDOM_RESULT SciterGetObject( HELEMENT he, tiscript_value* pval, BOOL forceCreation ) { return SAPI().SciterGetObject( he, pval, forceCreation ); }
SCDOM_RESULT SciterGetElementNamespace(  HELEMENT he, tiscript_value* pval) { return SAPI().SciterGetElementNamespace( he,pval); }
SCDOM_RESULT SciterGetHighlightedElement(HWINDOW hwnd, HELEMENT* phe) { return SAPI().SciterGetHighlightedElement(hwnd, phe); }
SCDOM_RESULT SciterSetHighlightedElement(HWINDOW hwnd, HELEMENT he) { return SAPI().SciterSetHighlightedElement(hwnd,he); }
SCDOM_RESULT SciterNodeAddRef(HNODE hn) { return SAPI().SciterNodeAddRef(hn); }
SCDOM_RESULT SciterNodeRelease(HNODE hn) { return SAPI().SciterNodeRelease(hn); }
SCDOM_RESULT SciterNodeCastFromElement(HELEMENT he, HNODE* phn) { return SAPI().SciterNodeCastFromElement(he,phn); }
SCDOM_RESULT SciterNodeCastToElement(HNODE hn, HELEMENT* he) { return SAPI().SciterNodeCastToElement(hn,he); }
SCDOM_RESULT SciterNodeFirstChild(HNODE hn, HNODE* phn) { return SAPI().SciterNodeFirstChild(hn,phn); }
SCDOM_RESULT SciterNodeLastChild(HNODE hn, HNODE* phn) { return SAPI().SciterNodeLastChild(hn, phn); }
SCDOM_RESULT SciterNodeNextSibling(HNODE hn, HNODE* phn) { return SAPI().SciterNodeNextSibling(hn, phn); }
SCDOM_RESULT SciterNodePrevSibling(HNODE hn, HNODE* phn) { return SAPI().SciterNodePrevSibling(hn,phn); }
SCDOM_RESULT SciterNodeParent(HNODE hnode, HELEMENT* pheParent) { return SAPI().SciterNodeParent(hnode,pheParent) ; }
SCDOM_RESULT SciterNodeNthChild(HNODE hnode, uint n, HNODE* phn) { return SAPI().SciterNodeNthChild(hnode,n,phn); }
SCDOM_RESULT SciterNodeChildrenCount(HNODE hnode, uint* pn) { return SAPI().SciterNodeChildrenCount(hnode, pn); }
SCDOM_RESULT SciterNodeType(HNODE hnode, uint* pNodeType /*NODE_TYPE*/) { return SAPI().SciterNodeType(hnode,pNodeType); }
SCDOM_RESULT SciterNodeGetText(HNODE hnode, LPCWSTR_RECEIVER rcv, void* rcv_param) { return SAPI().SciterNodeGetText(hnode,rcv,rcv_param); }
SCDOM_RESULT SciterNodeSetText(HNODE hnode, LPCWSTR text, uint textLength) { return SAPI().SciterNodeSetText(hnode,text,textLength); }
SCDOM_RESULT SciterNodeInsert(HNODE hnode, uint where /*NODE_INS_TARGET*/, HNODE what) { return SAPI().SciterNodeInsert(hnode,where,what); }
SCDOM_RESULT SciterNodeRemove(HNODE hnode, BOOL finalize) { return SAPI().SciterNodeRemove(hnode,finalize); }
SCDOM_RESULT SciterCreateTextNode(LPCWSTR text, uint textLength, HNODE* phnode) { return SAPI().SciterCreateTextNode(text,textLength,phnode); }
SCDOM_RESULT SciterCreateCommentNode(LPCWSTR text, uint textLength, HNODE* phnode) { return SAPI().SciterCreateCommentNode(text,textLength,phnode); }

HVM SciterGetVM( HWINDOW hwnd )  { return SAPI().SciterGetVM(hwnd); }

uint ValueInit ( VALUE* pval ) { return SAPI().ValueInit(pval); }
uint ValueClear ( VALUE* pval ) { return SAPI().ValueClear(pval); } 
uint ValueCompare ( const VALUE* pval1, const VALUE* pval2 ) { return SAPI().ValueCompare(pval1,pval2); }
uint ValueCopy ( VALUE* pdst, const VALUE* psrc ) { return SAPI().ValueCopy(pdst, psrc); }
uint ValueIsolate ( VALUE* pdst ) { return SAPI().ValueIsolate(pdst); }
uint ValueType ( const VALUE* pval, uint* pType, uint* pUnits ) { return SAPI().ValueType(pval,pType,pUnits); }
uint ValueStringData ( const VALUE* pval, LPCWSTR* pChars, uint* pNumChars ) { return SAPI().ValueStringData(pval,pChars,pNumChars); }
uint ValueStringDataSet ( VALUE* pval, LPCWSTR chars, uint numChars, uint units ) { return SAPI().ValueStringDataSet(pval, chars, numChars, units); }
uint ValueIntData ( const VALUE* pval, int* pData ) { return SAPI().ValueIntData ( pval, pData ); }
uint ValueIntDataSet ( VALUE* pval, int data, uint type, uint units ) { return SAPI().ValueIntDataSet ( pval, data,type,units ); }
uint ValueInt64Data ( const VALUE* pval, long* pData ) { return SAPI().ValueInt64Data ( pval,pData ); }
uint ValueInt64DataSet ( VALUE* pval, long data, uint type, uint units ) { return SAPI().ValueInt64DataSet ( pval,data,type,units ); }
uint ValueFloatData ( const VALUE* pval, FLOAT_VALUE* pData ) { return SAPI().ValueFloatData ( pval,pData ); }
uint ValueFloatDataSet ( VALUE* pval, FLOAT_VALUE data, uint type, uint units ) { return SAPI().ValueFloatDataSet ( pval,data,type,units ); }
uint ValueBinaryData ( const VALUE* pval, LPCBYTE* pBytes, uint* pnBytes ) { return SAPI().ValueBinaryData ( pval,pBytes,pnBytes ); }
uint ValueBinaryDataSet ( VALUE* pval, LPCBYTE pBytes, uint nBytes, uint type, uint units ) { return SAPI().ValueBinaryDataSet ( pval,pBytes,nBytes,type,units ); }
uint ValueElementsCount ( const VALUE* pval, int* pn) { return SAPI().ValueElementsCount ( pval,pn); }
uint ValueNthElementValue ( const VALUE* pval, int n, VALUE* pretval) { return SAPI().ValueNthElementValue ( pval, n, pretval); }
uint ValueNthElementValueSet ( VALUE* pval, int n, const VALUE* pval_to_set) { return SAPI().ValueNthElementValueSet ( pval,n,pval_to_set); }
uint ValueNthElementKey ( const VALUE* pval, int n, VALUE* pretval) { return SAPI().ValueNthElementKey ( pval,n,pretval); }
uint ValueEnumElements ( VALUE* pval, KeyValueCallback* penum, void* param) { return SAPI().ValueEnumElements (pval,penum,param); }
uint ValueSetValueToKey ( VALUE* pval, const VALUE* pkey, const VALUE* pval_to_set) { return SAPI().ValueSetValueToKey ( pval, pkey, pval_to_set); }
uint ValueGetValueOfKey ( const VALUE* pval, const VALUE* pkey, VALUE* pretval) { return SAPI().ValueGetValueOfKey ( pval, pkey,pretval); }
uint ValueToString ( VALUE* pval, uint how ) { return SAPI().ValueToString ( pval,how ); }
uint ValueFromString ( VALUE* pval, LPCWSTR str, uint strLength, uint how ) { return SAPI().ValueFromString ( pval, str,strLength,how ); }
uint ValueInvoke ( const VALUE* pval, const VALUE* pthis, uint argc, const VALUE* argv, VALUE* pretval, LPCWSTR url) { return SAPI().ValueInvoke ( pval, pthis, argc, argv, pretval, url); }
uint ValueNativeFunctorSet ( VALUE* pval, NATIVE_FUNCTOR_INVOKE* pinvoke, NATIVE_FUNCTOR_RELEASE* prelease, void* tag) { return SAPI().ValueNativeFunctorSet (pval, pinvoke, prelease, tag); }
BOOL ValueIsNativeFunctor ( const VALUE* pval) { return SAPI().ValueIsNativeFunctor (pval); }

// conversion between script (managed) value and the VALUE ( com::variant alike thing )
BOOL Sciter_v2V(HVM vm, const tiscript_value script_value, VALUE* out_value, BOOL isolate) { return SAPI().Sciter_v2V(vm,script_value,out_value, isolate); }
BOOL Sciter_V2v(HVM vm, const VALUE* value, tiscript_value* out_script_value) { return SAPI().Sciter_V2v(vm,value,out_script_value); }

UINT_PTR SciterPostCallback(HWINDOW hwnd, UINT_PTR wparam, UINT_PTR lparam, uint timeoutms) { return SAPI().SciterPostCallback(hwnd, wparam, lparam, timeoutms); }
